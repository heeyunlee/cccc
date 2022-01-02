import json
import datetime

import flask
from flask import (
    make_response,
    jsonify,
)

import plaid
from plaid.api import plaid_api
from plaid.model.products import Products
from plaid.model.country_code import CountryCode
from plaid.model.transaction import Transaction
from plaid.model.item import Item
from plaid.model.item_public_token_exchange_response import ItemPublicTokenExchangeResponse
from plaid.model.transactions_get_response import TransactionsGetResponse
from plaid.model.link_token_create_request_user import LinkTokenCreateRequestUser
from plaid.model.item_public_token_exchange_request import ItemPublicTokenExchangeRequest

from google.cloud import firestore
from google.cloud.firestore_v1.document import DocumentReference
from food_categories import update_transactions_data

f = open('private_keys.json')
data = json.load(f)
f.close()
client = firestore.Client()

food_category_id_list = [
    '13000000',
    '13001000',
    '13001001',
    '13001002',
    '13001003',
    '13002000',
    '13003000',
    '13004000',
    '13004001',
    '13004002',
    '13004003',
    '13004004',
    '13004005',
    '13004006',
    '13005000',
    '13005001',
    '13005002',
    '13005003',
    '13005004',
    '13005005',
    '13005006',
    '13005007',
    '13005008',
    '13005009',
    '13005010',
    '13005011',
    '13005012',
    '13005013',
    '13005014',
    '13005015',
    '13005016',
    '13005017',
    '13005018',
    '13005019',
    '13005020',
    '13005021',
    '13005022',
    '13005023',
    '13005024',
    '13005025',
    '13005026',
    '13005027',
    '13005028',
    '13005029',
    '13005030',
    '13005031',
    '13005032',
    '13005033',
    '13005034',
    '13005035',
    '13005036',
    '13005037',
    '13005038',
    '13005039',
    '13005040',
    '13005041',
    '13005042',
    '13005043',
    '13005044',
    '13005045',
    '13005046',
    '13005047',
    '13005048',
    '13005049',
    '13005050',
    '13005051',
    '13005052',
    '13005053',
    '13005054',
    '13005055',
    '13005056',
    '13005057',
    '13005058',
    '13005059',
    '18021000',
    '18021001',
    '18021002',
    '18037005',
    '19025000',
    '19025001',
    '19025002',
    '19025003',
    '19025004',
]

configuration = plaid.Configuration(
    host=plaid.Environment.Sandbox,
    api_key={
        'clientId': data['client_id'],
        'secret': data['secret_sandbox'],
    }
)

api_client = plaid.ApiClient(configuration)
plaid_client = plaid_api.PlaidApi(api_client)
firstore_client = firestore.Client()


def create_link_token(request: flask.Request):
    try:
        # Get UID from request
        data = request.get_data()
        data_decoded = data.decode('UTF-8')
        data_dict = json.loads(data_decoded)
        uid = data_dict['uid']
        print(f'uid is {uid}')

        # Create Link Token Request
        request = plaid_api.LinkTokenCreateRequest(
            products=[Products('auth'), Products('transactions')],
            client_name="CCCC",
            language='en',
            country_codes=[CountryCode('US')],
            user=LinkTokenCreateRequestUser(
                client_user_id=uid
            )
        )
        print(f'link_token_create_request {request}')

        # Create Link Token Response
        response: plaid_api.LinkTokenCreateResponse = plaid_client.link_token_create(
            request
        )
        print(f'link_token_create response= {response}')

        link_token: str = response['link_token']
        print(f'get_link_token worked! The token = {link_token}')

        jsonified_response = jsonify(link_token=link_token)
        print(f'jsonified_response {jsonified_response}')

        return jsonified_response
    except:
        error_response = make_response(jsonify('An Error Occurred'), 404)

        return error_response


def exchange_public_token(request: flask.Request) -> dict:
    try:
        data = request.get_data()
        print(f'data is {data}')

        data_decoded = data.decode('UTF-8')
        data_dict = json.loads(data_decoded)
        public_token = data_dict['public_token']
        uid = data_dict['uid']
        print(f'public_token is {public_token}')

        request = ItemPublicTokenExchangeRequest(public_token=public_token)
        response: ItemPublicTokenExchangeResponse = plaid_client.item_public_token_exchange(
            request
        )
        print(f'response is: {response.to_dict()}')

        access_token = response.access_token
        item_id = response.item_id
        request_id = response.request_id

        affected_doc = firstore_client.collection('users').document(uid)
        affected_doc.update({
            'plaidAccessToken': access_token,
            'plaidItemId': item_id,
            'plaidRequestId': request_id,
        })

        success_response = make_response(
            jsonify('Successfully updated user doc'), 200
        )

        return success_response
    except:
        error_response = make_response(jsonify('An Error Occurred'), 404)

        return error_response


def fetch_transaction_data(request: flask.Request):
    try:
        # Get `uid`, `start_date`, `end_date` and from request data
        data = request.get_data()
        data_decoded = data.decode('UTF-8')
        data_dict = json.loads(data_decoded)
        uid = data_dict['uid']
        start_date = datetime.datetime.strptime(
            data_dict['start_date'], '%Y-%m-%d %H:%M:%S.%f'
        )
        end_date = datetime.datetime.strptime(
            data_dict['end_date'], '%Y-%m-%d %H:%M:%S.%f'
        )

        # Get access token by accessing user doc on Firestore
        user_doc = firstore_client.collection('users').document(uid)
        user_doc_get = user_doc.get()
        user_dict = user_doc_get.to_dict()
        access_token = user_dict['plaidAccessToken']

        # Transactions Request
        transactions_get_request = plaid_api.TransactionsGetRequest(
            access_token=access_token,
            start_date=plaid_api.date(
                start_date.year, start_date.month, start_date.day
            ),
            end_date=plaid_api.date(
                end_date.year, end_date.month, end_date.day
            ),
        )

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

        return make_response(jsonify(f'Successfully updated transactions and accounts data'), 200)
    except Exception as e:
        return make_response(jsonify(f'An Error Occurred: {e}'), 404)


def update_transactions_data(data, context):
    print(f'''
    update_transactions_data data={data}
    update_transactions_data context={context}
    ''')

    # Get Transaction document from Firestore
    path_parts = context.resource.split('/documents/')[1].split('/')
    collection_path = path_parts[0]
    document_path = '/'.join(path_parts[1:])
    users_collection = client.collection(collection_path)
    transactions_doc = users_collection.document(document_path)

    # Get Transaction Data
    transactions_dict = transactions_doc.get().to_dict()
    print('transactions_dict:', transactions_dict)
    print('type is:', type(transactions_dict))

    # Transaction Category Id
    category_id = transactions_dict['category_id']

    # Update Transaction is_food_category field
    if category_id in food_category_id_list:
        print('Transaction is a food category')

        transactions_dict.update({
            'is_food_category': True,
        })
    else:
        print('Transaction is NOT a food category')

        transactions_dict.update({
            'is_food_category': False,
        })

    # Update Transaction Data
    transactions_doc.update(transactions_dict)

    print('Successfully updated transaction data')
