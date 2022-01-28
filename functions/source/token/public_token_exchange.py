import json
from typing import Any, Dict, Union

from plaid import ApiException
from plaid.model.item_public_token_exchange_request import \
    ItemPublicTokenExchangeRequest
from plaid.model.item_public_token_exchange_response import \
    ItemPublicTokenExchangeResponse

from source.configuration import plaid_client

''' Exchange public token for an access token

    Exchange a Link `public_token` for an API access_token. Link hands off the 
    `public_token` client-side via the onSuccess callback once a user has successfully 
    created an Item. The `public_token` is ephemeral and expires after 30 minutes.

    The response also includes an `item_id` that should be stored with the `access_token`. 
    The `item_id` is used to identify an Item in a webhook. The `item_id` can also be 
    retrieved by making an `/item/get` request.
'''


def public_token_exchange(public_token: Union[str, None]) -> Dict[str, Any]:
    try:

        if public_token is None:
            return {'error_code': 404, 'error_message': 'public_token is None'}

        # Make Request to exchange public_token_to_access_token
        request = ItemPublicTokenExchangeRequest(public_token)
        response: ItemPublicTokenExchangeResponse = plaid_client.item_public_token_exchange(
            request)
        response_dict = response.to_dict()
        print(f'exchange response dict: \n{response_dict}')

        return response_dict
    except ApiException as e:
        exceptions: dict = json.loads(e.body)
        return exceptions
