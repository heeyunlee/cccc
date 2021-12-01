import json
import plaid
from plaid.api import plaid_api
from plaid.model.products import Products
from plaid.model.country_code import CountryCode
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


def get_link_token() -> str:

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

    link_token = response['link_token']

    print(f'get_link_token worked! The token = {link_token}')

    return link_token


def fetch_transaction_data(access_token: str):

    request = plaid_api.TransactionsGetRequest(
        access_token=access_token,
        start_date=plaid_api.date(2021, 11, 29),
        end_date=plaid_api.date(2021, 12, 1),
    )

    response = client.transactions_get(request)
    transactions = response['transactions']

    return transactions


def exchange_public_token(public_token: str) -> str:
    request = ItemPublicTokenExchangeRequest(
        public_token=public_token
    )

    response = client.item_public_token_exchange(request)
    access_token = response['access_token']

    return access_token
