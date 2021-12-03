import json
from flask.json import jsonify
import plaid
import flask
from flask import make_response
from plaid.api import plaid_api
from plaid.model.products import Products
from plaid.model.country_code import CountryCode
from plaid.model.transaction import Transaction
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
        # print(f'request is {request}')

        data = request.get_data()
        # print(f'data is {data}')

        public_token = data.decode('UTF-8')
        # print(f'public token = {public_token}')

        request_public = ItemPublicTokenExchangeRequest(
            public_token=public_token
        )

        response_access_token = client.item_public_token_exchange(
            request_public
        )
        access_token = response_access_token['access_token']

        print(f'Response to Public Token Exchange: {access_token}')

        request_transactions = plaid_api.TransactionsGetRequest(
            access_token=access_token,
            start_date=plaid_api.date(2021, 11, 29),
            end_date=plaid_api.date(2021, 12, 1),
        )
        response_transactions = client.transactions_get(request_transactions)
        transactions: list[Transaction] = response_transactions['transactions']

        print(f'type of transactions are {type(transactions)}')

        transactions_dict = [x.to_dict() for x in transactions]

        print(f'transactions_dict is {transactions_dict}')

        return make_response(jsonify(transactions_dict), 200)

    except:
        return make_response(jsonify('An Error Occurred'), 404)
