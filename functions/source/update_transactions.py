from datetime import date, datetime
from typing import Any, Dict, List, Union

from google.cloud.firestore import DocumentReference

from source.configuration import firestore_client


def update_transactions(uid: str, transactions: List[Dict[str, Any]]):
    try:
        user_doc = firestore_client.collection('users').document(uid)
        transactions_collection = user_doc.collection('transactions')

        for transaction in transactions:
            transaction_id: Union[str, None] = transaction.get(
                'transaction_id')
            transaction_doc: DocumentReference = transactions_collection.document(
                transaction_id
            )
            transaction_snapshot = transaction_doc.get()

            old_date: date = transaction.get('date')
            new_date = datetime(old_date.year, old_date.month, old_date.day)

            authorized_date: Union[date, None] = transaction.get(
                'authorized_date')

            if authorized_date is not None:
                new_authorized_date = datetime(
                    authorized_date.year, authorized_date.month, authorized_date.day)
            else:
                new_authorized_date = None

            transaction.update({
                'date': new_date,
                'authorized_date': new_authorized_date,
            })

            if transaction_snapshot.exists:
                write_result = transaction_doc.update(transaction)
                update_time = write_result.update_time
            else:
                write_result = transaction_doc.create(transaction)
                update_time = write_result.update_time

        return {'status': 200, 'last_update_time': update_time}
    except Exception as e:
        return {'status': 404, 'error_message': str(e)}
