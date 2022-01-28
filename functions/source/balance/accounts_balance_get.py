import json
from typing import Dict, Any

from plaid import ApiException
from plaid.model.accounts_balance_get_request import AccountsBalanceGetRequest
from plaid.model.accounts_balance_get_request_options import AccountsBalanceGetRequestOptions
from plaid.model.accounts_get_response import AccountsGetResponse

from source.configuration import plaid_client

''' Retrieve real-time balance data

    The `/accounts/balance/get` endpoint returns the real-time balance for each of 
    an Item's accounts. While other endpoints may return a balance object, only 
    `/accounts/balance/get` forces the available and current balance fields to be 
    refreshed rather than cached. This endpoint can be used for existing Items that 
    were added via any of Plaid’s other products. This endpoint can be used as long 
    as Link has been initialized with any other product, balance itself is not a product 
    that can be used to initialize Link.
'''


def accounts_balance_get(access_token: str):
    try:
        request = AccountsBalanceGetRequest(access_token)
        response: AccountsGetResponse = plaid_client.accounts_balance_get(
            request)

        return response.to_dict()
    except ApiException as e:
        exceptions: dict = json.loads(e.body)
        return exceptions
