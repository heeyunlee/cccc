import json
import plaid
from plaid.api import plaid_api

with open('private_keys.json') as f:
    data: dict = json.load(f)
    f.close()

configuration = plaid.Configuration(
    host=plaid.Environment.Development,
    # host=plaid.Environment.Sandbox,
    api_key={
        'clientId': data.get('client_id'),
        'secret': data.get('secret_development'),
        # 'secret': data.get('secret_sandbox'),
    }
)

api_client = plaid.ApiClient(configuration)
plaid_client = plaid_api.PlaidApi(api_client)
