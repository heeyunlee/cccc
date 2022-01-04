import json
import plaid
from plaid.api import plaid_api

from google.cloud import firestore

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
firestore_client = firestore.Client()
