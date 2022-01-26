import json
from typing import Any, Dict

from plaid import ApiException
from plaid.model.item_public_token_exchange_request import \
    ItemPublicTokenExchangeRequest
from plaid.model.item_public_token_exchange_response import \
    ItemPublicTokenExchangeResponse
from plaid.model.products import Products
from plaid.model.sandbox_public_token_create_request import \
    SandboxPublicTokenCreateRequest
from plaid.model.sandbox_public_token_create_response import \
    SandboxPublicTokenCreateResponse

from source.configuration import plaid_client


def exchange_public_token(is_sandbox: bool, request_dict: Dict[str, Any]) -> Dict[str, Any]:
    try:
        # Get `public_token`
        if is_sandbox:
            pt_request = SandboxPublicTokenCreateRequest(
                institution_id='ins_3',
                initial_products=[Products('transactions')],
            )

            pt_response: SandboxPublicTokenCreateResponse = plaid_client.sandbox_public_token_create(
                pt_request
            )

            public_token = pt_response.public_token
        else:
            public_token: str = request_dict.get('public_token')

        # Make Request to exchange
        exchange_request = ItemPublicTokenExchangeRequest(
            public_token=public_token
        )
        print(f'exchange request: \n{exchange_request}')

        exchange_response: ItemPublicTokenExchangeResponse = plaid_client.item_public_token_exchange(
            exchange_request
        )
        exchange_response_dict = exchange_response.to_dict()
        print(f'exchange response dict: \n{exchange_response_dict}')

        return exchange_response_dict
    except ApiException as e:
        exceptions: dict = json.loads(e.body)
        return exceptions
