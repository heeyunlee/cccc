import plaid
from plaid.api import plaid_api
from plaid.model.country_code import CountryCode
from plaid.model.link_token_create_request_user import LinkTokenCreateRequestUser
from plaid.model.products import Products
import json


def get_private_keys() -> json:
    f = open('private_keys.json')
    data = json.load(f)
    f.close()

    return data


def get_plaid_link_token() -> str:

    configuration = plaid.Configuration(
        host=plaid.Environment.Sandbox,
        api_key={
            'clientId': get_private_keys()['client_id'],
            'secret': get_private_keys()['secret'],
        }
    )

    api_client = plaid.ApiClient(configuration)
    client = plaid_api.PlaidApi(api_client)

    # create link token
    response = client.link_token_create(
        plaid_api.LinkTokenCreateRequest(
            products=[Products('auth'), Products('transactions')],
            client_name="Plaid Test App",
            language='en',
            country_codes=[CountryCode('US')],
            user=LinkTokenCreateRequestUser(
                client_user_id='123-test-user-id'
            )
        )
    )

    link_token = response['link_token']

    return link_token


print(get_plaid_link_token())
