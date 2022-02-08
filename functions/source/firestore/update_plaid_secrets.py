from datetime import date, datetime, timedelta
from typing import Dict, List, Union

from google.cloud import firestore
from google.cloud.firestore import CollectionReference


def update_plaid_secrets(uid: str, institution_id: str, transactions: List[Dict]):
    try:
        client = firestore.Client()
        user_ref = client.collection('users').document(uid)
        plaid_secret: CollectionReference = user_ref.collection(
            'plaid_secrets')
        institution_secret_ref = plaid_secret.document(institution_id)

        def get_pending_transaction(transaction: dict):
            return transaction.get('pending') == True

        first_pending_transaction: Union[Dict, None] = next(
            filter(get_pending_transaction, reversed(transactions)), None)
        print(first_pending_transaction)

        if first_pending_transaction is None:
            now = datetime.now()
            three_days_ago = now - timedelta(3)
            first_pending_transaction_date = datetime(
                three_days_ago.year,
                three_days_ago.month,
                three_days_ago.day,
            )
        else:
            fetched_date: date = first_pending_transaction.get('date')
            first_pending_transaction_date = fetched_date - timedelta(3)
            first_pending_transaction_date = datetime(
                first_pending_transaction_date.year,
                first_pending_transaction_date.month,
                first_pending_transaction_date.day
            )

        institution_secret_ref.update({
            'first_pending_transaction_date': first_pending_transaction_date,
        })

        return {'status': 200, 'message': 'Successfully updated plaid secret'}
    except Exception as e:
        return {'status': 404, 'message': str(e)}
