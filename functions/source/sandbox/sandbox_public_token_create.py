import json
from typing import Any, Dict

from plaid import ApiException
from plaid.model.products import Products
from plaid.model.sandbox_public_token_create_request import \
    SandboxPublicTokenCreateRequest
from plaid.model.sandbox_public_token_create_response import \
    SandboxPublicTokenCreateResponse

from source.test_configuration import plaid_client

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

        response: SandboxPublicTokenCreateResponse = plaid_client.sandbox_public_token_create(
            request
        )
        response_dict = response.to_dict()

        return response_dict
    except ApiException as e:
        exceptions: dict = json.loads(e.body)

        return exceptions
