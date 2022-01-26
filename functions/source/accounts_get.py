import json
from typing import List, Union

from plaid import ApiException
from plaid.model.accounts_get_request import AccountsGetRequest
from plaid.model.accounts_get_response import AccountsGetResponse

from source.configuration import plaid_client


def accounts_get(access_token: str) -> Union[List[dict], dict]:
    try:
        request = AccountsGetRequest(access_token)
        response: AccountsGetResponse = plaid_client.accounts_get(request)
        accounts: List[dict] = response['accounts']

        return accounts
    except ApiException as e:
        exceptions: dict = json.loads(e.body)
        return exceptions
