import json
from typing import Any, Dict, Optional

import flask

import plaid
from firestore.get_access_token_for_institution import get_access_token_for_institution
from plaid import ApiException
from plaid.api import plaid_api
from plaid.model.country_code import CountryCode
from plaid.model.item_access_token_invalidate_request import ItemAccessTokenInvalidateRequest
from plaid.model.item_access_token_invalidate_response import ItemAccessTokenInvalidateResponse
from plaid.model.item_public_token_exchange_request import ItemPublicTokenExchangeRequest
from plaid.model.item_public_token_exchange_response import ItemPublicTokenExchangeResponse
from plaid.model.link_token_create_request_user import LinkTokenCreateRequestUser
from plaid.model.products import Products
from plaid_configuration import PlaidConfiguration

# TODO: Change to Development or Production for release
plaid_config = PlaidConfiguration(plaid.Environment.Development)
client = plaid_config.client()

''' Create Link Token

    The `/link/token/create` endpoint creates a link_token, which is required as 
    a parameter when initializing Link. Once Link has been initialized, it returns 
    a `public_token`, which can then be exchanged for an `access_token` via 
    `/item/public_token/exchange` as part of the main Link flow.

    A link_token generated by `/link/token/create` is also used to initialize other 
    Link flows, such as the update mode flow for tokens with expired credentials, 
    or the Payment Initiation (Europe) flow.
'''


def create_link_token(request: flask.Request) -> Dict[str, Any]:
    # ^ TODO: Change the data type to flask.Request for release

    # Get UID from request
    data_dict: dict = json.loads(request.data)  # for release
    # data_dict: dict = request # For Testing
    uid: Optional[str] = data_dict.get('uid')

    if uid is None:
        return {'status': 404, 'error_message': 'uid was None'}

    try:
        request = plaid_api.LinkTokenCreateRequest(
            products=[Products('transactions')],
            client_name="CCCC",
            language='en',
            country_codes=[CountryCode('US')],
            user=LinkTokenCreateRequestUser(client_user_id=uid)
        )
        response: plaid_api.LinkTokenCreateResponse = client.link_token_create(
            request
        )
        print(f'link_token_create response: \n{response}')

        return response.to_dict()
    except ApiException as e:
        exceptions: dict = json.loads(e.body)

        return exceptions


def create_link_token_update_mode(request: flask.Request) -> Dict[str, Any]:
    # TODO: ^change the data type to flask.Request for release

    # TODO: for development
    # Get `uid` and `institution_id` from request
    data_dict: dict = json.loads(request.data)
    uid = data_dict.get('uid')
    institution_id = data_dict.get('institution_id')

    if (uid and institution_id) is None:
        return {'status': 404, 'error_message': 'Either access_token, uid, institution_id was None. Please send the data correctly'}

    response = get_access_token_for_institution(uid, institution_id)
    access_token = response.get('access_token')

    if access_token is None:
        return response

    try:
        request = plaid_api.LinkTokenCreateRequest(
            client_name='CCCC',
            language='en',
            access_token=access_token,
            country_codes=[CountryCode('US')],
            user=LinkTokenCreateRequestUser(client_user_id=uid)
        )
        response: plaid_api.LinkTokenCreateResponse = client.link_token_create(
            request
        )

        return response.to_dict()
    except ApiException as e:
        return json.loads(e.body)


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
        response: ItemPublicTokenExchangeResponse = client.item_public_token_exchange(
            request
        )

        return response.to_dict()
    except ApiException as e:
        exceptions: dict = json.loads(e.body)
        return exceptions


''' Invalidate access_token

    By default, the access_token associated with an Item does not expire and should 
    be stored in a persistent, secure manner.

    You can use the /item/access_token/invalidate endpoint to rotate the access_token 
    associated with an Item. The endpoint returns a new access_token and immediately 
    invalidates the previous access_token.
'''


def invalidate_access_token(access_token: str):
    try:
        request = ItemAccessTokenInvalidateRequest(access_token)
        response: ItemAccessTokenInvalidateResponse = client.item_access_token_invalidate(
            request
        )

        return response.to_dict()
    except ApiException as e:
        exceptions: dict = json.loads(e.body)
        return exceptions
