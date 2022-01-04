import datetime
import json

import flask
from google.cloud.firestore_v1.document import DocumentReference
from plaid.api import plaid_api
from plaid.model.transactions_get_request_options import \
    TransactionsGetRequestOptions
from plaid.model.transactions_get_response import TransactionsGetResponse

from source.configuration import firestore_client, plaid_client


def get_transactions(request: flask.Request):
    try:
        # Load request data
        data = request.get_data()
        data_decoded = data.decode('UTF-8')
        data_dict = json.loads(data_decoded)
        uid = data_dict['uid']

        # Get [accessToken] and [accountIds] by accessing user doc on Firestore
        user_doc = firestore_client.collection('users').document(uid)
        user_doc_get = user_doc.get()
        user_dict = user_doc_get.to_dict()
        access_token = user_dict['plaidAccessToken']
        print(f'access_token is {access_token}')

        linked_accounts = user_dict['accountsIds']
        print('linked_accounts are: ', linked_accounts)

        # Transactions Request
        start_date = datetime.datetime.strptime(
            data_dict['start_date'], '%Y-%m-%d %H:%M:%S.%f'
        )
        start_date_plaid = plaid_api.date(
            start_date.year, start_date.month, start_date.day
        ),
        print(f'start_date_plaid: {start_date_plaid}')

        end_date = datetime.datetime.strptime(
            data_dict['end_date'], '%Y-%m-%d %H:%M:%S.%f'
        )
        end_date_plaid = plaid_api.date(
            end_date.year, end_date.month, end_date.day
        ),
        print(f'end_date_plaid: {end_date_plaid}')

        # requestOptions = TransactionsGetRequestOptions(
        #     account_ids=linked_accounts,
        # )
        transactions_get_request = plaid_api.TransactionsGetRequest(
            access_token=access_token,
            start_date=start_date.date(),
            end_date=end_date.date(),
        )
        print(f'transactions_get_request is: {transactions_get_request}')

        # Transactions Response
        transactions_get_response: TransactionsGetResponse = plaid_client.transactions_get(
            transactions_get_request
        )
        response_dict = transactions_get_response.to_dict()

        # Update or Create Transactions Data
        transactions = response_dict['transactions']
        print(f'Retrieved {len(transactions)} transactions')

        for transaction in transactions:
            transaction: dict = transaction

            transaction_id: str = transaction['transaction_id']

            transactions_collection = user_doc.collection('transactions')
            transaction_doc: DocumentReference = transactions_collection.document(
                transaction_id
            )
            transaction_doc_dict = transaction_doc.get().to_dict()

            date_str = transaction['date'].strftime(
                '%Y-%m-%d'+'T'+'%H:%M:%S'+'Z'
            )

            # datetime
            if transaction['datetime'] is not None:
                datetime_str = transaction['datetime'].strftime(
                    '%Y-%m-%d'+'T'+'%H:%M:%S'+'Z'
                )
            else:
                datetime_str = None

            # authorized_date
            if transaction['authorized_date'] is not None:
                authorized_date_str = transaction['authorized_date'].strftime(
                    '%Y-%m-%d'+'T'+'%H:%M:%S'+'Z'
                )
            else:
                authorized_date_str = None

            # authorized_datetime
            if transaction['authorized_datetime'] is not None:
                authorized_datetime_str = transaction['authorized_datetime'].strftime(
                    '%Y-%m-%d'+'T'+'%H:%M:%S'+'Z'
                )
            else:
                authorized_datetime_str = None

            transaction.update({
                'date': date_str,
                'datetime': datetime_str,
                'authorized_date': authorized_date_str,
                'authorized_datetime': authorized_datetime_str,
            })

            if transaction_doc_dict is None:
                transaction_doc.create(transaction)
            elif transaction_doc_dict != transaction:
                transaction_doc.update(transaction)

        # Update or Create Accounts Data
        accounts = response_dict['accounts']

        print(f'Retrieved {len(accounts)} Accounts')

        for account in accounts:
            account: dict

            account_id = account['account_id']
            accounts_collection = user_doc.collection('accounts')
            account_doc: DocumentReference = accounts_collection.document(
                account_id
            )
            account_doc_dict = account_doc.get().to_dict()

            if account_doc_dict is None:
                account_doc.create(account)
            elif account_doc_dict != account:
                account_doc.update(account)

            success_response = flask.jsonify(
                f'Successfully updated transactions and accounts data')

        return flask.make_response(success_response, 200)
    except Exception as e:
        error_response = flask.jsonify(f'An Error Occurred: {e}')

        return flask.make_response(error_response, 404)
