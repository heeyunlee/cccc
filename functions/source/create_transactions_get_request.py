from datetime import datetime, timedelta

from google.cloud.firestore import DocumentReference
from plaid.api import plaid_api


def create_transactions_get_request(user_doc: DocumentReference, account_id: str):

    #### Get `access_token` ####
    plaid_keys_collection = user_doc.collection('plaid_keys')
    access_token_doc = plaid_keys_collection.document(account_id)
    access_token_dict = access_token_doc.get().to_dict()
    access_token = access_token_dict['access_token']

    #### Set `start_date` and `end_date` for request ####
    accounts_collection = user_doc.collection('accounts')
    account_doc = accounts_collection.document(account_id)
    account_dict = account_doc.get().to_dict()

    if account_dict is None:
        now = datetime.now()
        start_time = now - timedelta(days=60)
        start_date = start_time.date()
    else:
        start_time = account_dict.get('last_synced_time')

        if start_time is None:
            now = datetime.now()
            start_time = now - timedelta(days=60)
            start_date = start_time.date()
        else:
            start_time = datetime.strptime(
                str(start_time),
                '%Y-%m-%d %H:%M:%S.%f+00:00'
            )
            start_date = start_time.date()

    end_date = datetime.now().date()

    transactions_get_request = plaid_api.TransactionsGetRequest(
        access_token=access_token,
        start_date=start_date,
        end_date=end_date,
    )

    return transactions_get_request
