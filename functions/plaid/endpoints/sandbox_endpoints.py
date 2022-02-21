import json
from typing import Any, Dict

import plaid
from plaid import ApiException
from plaid.model.products import Products
from plaid.model.sandbox_item_reset_login_request import SandboxItemResetLoginRequest
from plaid.model.sandbox_item_reset_login_response import SandboxItemResetLoginResponse
from plaid.model.sandbox_public_token_create_request import SandboxPublicTokenCreateRequest
from plaid.model.sandbox_public_token_create_response import SandboxPublicTokenCreateResponse
from plaid_configuration import PlaidConfiguration

plaid_config = PlaidConfiguration(plaid.Environment.Sandbox)
client = plaid_config.client()

''' Force a Sandbox Item into an error state

    `/sandbox/item/reset_login/` forces an Item into an `ITEM_LOGIN_REQUIRED` 
    state in order to simulate an Item whose login is no longer valid. This makes 
    it easy to test Link's update mode flow in the Sandbox environment. After calling 
    `/sandbox/item/reset_login`, You can then use Plaid Link update mode to restore 
    the Item to a good state. An `ITEM_LOGIN_REQUIRED` webhook will also be fired 
    after a call to this endpoint, if one is associated with the Item.

    In the Sandbox, Items will transition to an `ITEM_LOGIN_REQUIRED` error state 
    automatically after 30 days, even if this endpoint is not called.
'''


def sandbox_item_reset_login(access_token: str):
    try:
        request = SandboxItemResetLoginRequest(access_token)
        response: SandboxItemResetLoginResponse = client.sandbox_item_reset_login(
            request
        )

        return response.to_dict()
    except ApiException as e:
        exceptions: dict = json.loads(e.body)
        return exceptions


''' Create a test Item

    Use the `/sandbox/public_token/create` endpoint to create a valid `public_token` 
    for an arbitrary institution ID, initial products, and test credentials. The 
    created `public_token` maps to a new Sandbox Item. You can then call 
    `/item/public_token/exchange` to exchange the `public_token` for an `access_token` 
    and perform all API actions. `/sandbox/public_token/create` can also be used with 
    the user_custom test username to generate a test account with custom data. 
    `/sandbox/public_token/create` cannot be used with OAuth institutions.
'''


def sandbox_public_token_create(institution_id: str) -> Dict[str, Any]:
    try:
        request = SandboxPublicTokenCreateRequest(
            institution_id=institution_id,
            initial_products=[Products('transactions')],
        )
        response: SandboxPublicTokenCreateResponse = client.sandbox_public_token_create(
            request
        )
        response_dict = response.to_dict()

        return response_dict
    except ApiException as e:
        exceptions: dict = json.loads(e.body)

        return exceptions
