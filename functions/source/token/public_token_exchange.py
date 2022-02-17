import json
from typing import Any, Dict

import plaid
from plaid import ApiException
from plaid.model.item_public_token_exchange_request import ItemPublicTokenExchangeRequest
from plaid.model.item_public_token_exchange_response import ItemPublicTokenExchangeResponse
from source.plaid_configuration import PlaidConfiguration

''' Exchange public token for an access token

    Exchange a Link `public_token` for an API access_token. Link hands off the 
    `public_token` client-side via the onSuccess callback once a user has successfully 
    created an Item. The `public_token` is ephemeral and expires after 30 minutes.

    The response also includes an `item_id` that should be stored with the `access_token`. 
    The `item_id` is used to identify an Item in a webhook. The `item_id` can also be 
    retrieved by making an `/item/get` request.
'''


def public_token_exchange(public_token: str) -> Dict[str, Any]:
    try:
        # Make Request to exchange `public_token` to `access_token`
        request = ItemPublicTokenExchangeRequest(public_token)

        # TODO: Change to Development or Production for release
        plaid_config = PlaidConfiguration(plaid.Environment.Development)
        client = plaid_config.client()

        response: ItemPublicTokenExchangeResponse = client.item_public_token_exchange(
            request
        )

        return response.to_dict()
    except ApiException as e:
        exceptions: dict = json.loads(e.body)
        return exceptions
