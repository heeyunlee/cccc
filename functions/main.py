import json
import datetime
from flask.json import jsonify
import plaid
import flask
from flask import make_response
from plaid.api import plaid_api
from plaid.model.products import Products
from plaid.model.country_code import CountryCode
from plaid.model.transaction import Transaction
from plaid.model.item import Item
from plaid.model.item_public_token_exchange_response import ItemPublicTokenExchangeResponse
from plaid.model.transactions_get_response import TransactionsGetResponse
from plaid.model.link_token_create_request_user import LinkTokenCreateRequestUser
from plaid.model.item_public_token_exchange_request import ItemPublicTokenExchangeRequest


f = open('private_keys.json')
data = json.load(f)
f.close()

configuration = plaid.Configuration(
    host=plaid.Environment.Sandbox,
    api_key={
        'clientId': data['client_id'],
        'secret': data['secret'],
    }
)

api_client = plaid.ApiClient(configuration)
client = plaid_api.PlaidApi(api_client)


def get_link_token(a: str) -> str:

    # create link token
    response = client.link_token_create(
        plaid_api.LinkTokenCreateRequest(
            products=[Products('auth'), Products('transactions')],
            client_name="CCCC",
            language='en',
            country_codes=[CountryCode('US')],
            user=LinkTokenCreateRequestUser(
                client_user_id='123-test-user-id'
            )
        )
    )

    link_token: str = response['link_token']

    print(f'get_link_token worked! The token = {link_token}')

    return link_token


def fetch_transaction_data(request: flask.Request):
    try:
        print(f'request: {request}')

        data = request.get_data()
        data_decoded = data.decode('UTF-8')
        data_dict = json.loads(data_decoded)

        print(f'decoded data {data_dict}')

        public_token = data_dict['public_token']
        print(f'public_token is {public_token}')

        start_date = datetime.datetime.strptime(
            data_dict['start_date'], '%Y-%m-%d %H:%M:%S.%f'
        )
        print(f'start_date is {start_date}')

        end_date = datetime.datetime.strptime(
            data_dict['end_date'], '%Y-%m-%d %H:%M:%S.%f'
        )
        print(f'end_date is {end_date}')

        exchange_token_request = ItemPublicTokenExchangeRequest(
            public_token=public_token
        )
        exchange_token_response: ItemPublicTokenExchangeResponse = client.item_public_token_exchange(
            exchange_token_request
        )
        access_token = exchange_token_response.access_token

        print(f'item_public_token_exchange response: {access_token}')

        transactions_get_request = plaid_api.TransactionsGetRequest(
            access_token=access_token,
            start_date=plaid_api.date(
                start_date.year, start_date.month, start_date.day
            ),
            end_date=plaid_api.date(
                end_date.year, end_date.month, end_date.day
            ),
        )
        transactions_get_response: TransactionsGetResponse = client.transactions_get(
            transactions_get_request
        )

        print(f'response_transactions is: {transactions_get_response}')

        response_dict = transactions_get_response.to_dict()

        return make_response(jsonify(response_dict), 200)
    except:
        return make_response(jsonify('An Error Occurred'), 404)
