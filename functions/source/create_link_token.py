import json
from typing import Any, Dict, Union

import flask
from plaid import ApiException
from plaid.api import plaid_api
from plaid.model.country_code import CountryCode
from plaid.model.link_token_create_request_user import \
    LinkTokenCreateRequestUser
from plaid.model.products import Products

from source.configuration import plaid_client


def create_link_token(request: Union[flask.Request, Dict[str, Any]]) -> Dict[str, Any]:

    # Get UID from request
    if type(request) is flask.Request:
        data = request.data
        data_dict: dict = json.loads(data)
    else:
        data_dict = request

    uid: Union[str, None] = data_dict.get('uid')

    try:
        # Create Link Token Request
        request = plaid_api.LinkTokenCreateRequest(
            products=[Products('transactions')],
            client_name="CCCC",
            language='en',
            country_codes=[CountryCode('US')],
            user=LinkTokenCreateRequestUser(
                client_user_id=uid
            )
        )
        print(f'link_token_create_request \n{request}')

        # Create Link Token Response
        response: plaid_api.LinkTokenCreateResponse = plaid_client.link_token_create(
            request
        )
        print(f'link_token_create response = \n{response}')

        return response.to_dict()
    except ApiException as e:
        exceptions: dict = json.loads(e.body)

        return exceptions
