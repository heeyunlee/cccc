import json

import plaid
from plaid.api import plaid_api


class PlaidConfiguration():
    def __init__(self, env: plaid.Environment):
        self.env = env

    def client(self):
        with open('private_keys.json') as f:
            data: dict = json.load(f)
            f.close()

        if self.env == plaid.Environment.Development:
            configuration = plaid.Configuration(
                host=plaid.Environment.Development,
                api_key={
                    'clientId': data.get('client_id'),
                    'secret': data.get('secret_development'),
                },
            )
        elif self.env == plaid.Environment.Production:
            configuration = plaid.Configuration(
                host=plaid.Environment.Production,
                api_key={
                    'clientId': data.get('client_id'),
                    'secret': data.get('secret_production'),
                },
            )
        else:
            configuration = plaid.Configuration(
                host=plaid.Environment.Sandbox,
                api_key={
                    'clientId': data.get('client_id'),
                    'secret': data.get('secret_sandbox'),
                },
            )

        api_client = plaid.ApiClient(configuration)
        plaid_client = plaid_api.PlaidApi(api_client)

        return plaid_client
