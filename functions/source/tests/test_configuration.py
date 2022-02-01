import json

import plaid
from google.cloud import firestore
from plaid.api import plaid_api

private_keys_path = '../../private_keys.json'
google_services_path = '../../google-services.json'

with open(private_keys_path) as f:
    data: dict = json.load(f)
    f.close()

configuration = plaid.Configuration(
    # host=plaid.Environment.Sandbox,
    host=plaid.Environment.Development,
    api_key={
        'clientId': data.get('client_id'),
        # 'secret': data.get('secret_sandbox'),
        'secret': data.get('secret_development'),
    }
)

api_client = plaid.ApiClient(configuration)
plaid_client = plaid_api.PlaidApi(api_client)
firestore_client = firestore.Client.from_service_account_json(
    google_services_path)
