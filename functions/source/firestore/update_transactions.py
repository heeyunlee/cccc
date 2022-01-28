from datetime import date, datetime
from typing import Any, Dict, List, Union

from google.cloud.firestore import CollectionReference
from source.configuration import firestore_client


def update_transactions(uid: str, transactions: List[Dict[str, Any]]):
    try:
        updated_transactions_length = 0
        user_doc = firestore_client.collection('users').document(uid)
        transactions_collection: CollectionReference = user_doc.collection(
            'transactions')

        for transaction in transactions:
            transaction_id = transaction.get('transaction_id')
            transaction_doc = transactions_collection.document(transaction_id)
            transaction_snapshot = transaction_doc.get()
            pending = transaction_snapshot.get('pending')

            if transaction_snapshot.exists and not pending:
                continue

            old_date: date = transaction.get('date')
            new_date = datetime(old_date.year, old_date.month, old_date.day)

            authorized_date: Union[date, None] = transaction.get(
                'authorized_date')

            if authorized_date is not None:
                authorized_date = datetime(
                    authorized_date.year, authorized_date.month, authorized_date.day)

            transaction.update({
                'date': new_date,
                'authorized_date': authorized_date,
            })

            if transaction_snapshot.exists:
                transaction_doc.update(transaction)
            else:
                transaction_doc.create(transaction)

            updated_transactions_length += 1

        return {'status': 200, 'message': 'successfully updated transactions data', 'updated_transactions_length': updated_transactions_length}
    except Exception as e:
        return {'status': 404, 'error_message': str(e)}
