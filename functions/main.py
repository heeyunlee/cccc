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

f = open('private_keys.json')
data = json.load(f)
f.close()

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

        user_doc = firstore_client.collection('users').document(uid)
        user_doc_get = user_doc.get()
        user_dict = user_doc_get.to_dict()
        access_token = user_dict['plaidAccessToken']

        transactions_get_request = plaid_api.TransactionsGetRequest(
            access_token=access_token,
            start_date=plaid_api.date(
                start_date.year, start_date.month, start_date.day
            ),
            end_date=plaid_api.date(
                end_date.year, end_date.month, end_date.day
            ),
        )
        transactions_get_response: TransactionsGetResponse = plaid_client.transactions_get(
            transactions_get_request
        )
        response_dict = transactions_get_response.to_dict()
        transactions = response_dict['transactions']

        # print(f'transaction type is {type(transactions)}')
        print('transactions are: ', transactions)

        for transaction in transactions:
            transaction: dict = transaction
            print(f'old transaction is {transaction}')

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

            print(f'new transaction is {transaction}')

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

        return make_response(jsonify(transactions), 200)
    except Exception as e:
        return make_response(jsonify(f'An Error Occurred: {e}'), 404)
