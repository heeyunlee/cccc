import json

import flask
from flask import jsonify, make_response
from plaid.api import plaid_api
from plaid.model.country_code import CountryCode
from plaid.model.link_token_create_request_user import \
    LinkTokenCreateRequestUser
from plaid.model.products import Products

from source.configuration import plaid_client


def create_link_token(request: flask.Request):
    try:
        # Get UID from request
        data = request.get_data()
        data_decoded = data.decode('UTF-8')
        data_dict = json.loads(data_decoded)
        uid = data_dict['uid']
        print(f'uid is {uid}')

        # Create Link Token Request
        request = plaid_api.LinkTokenCreateRequest(
            products=[Products('auth'), Products('transactions')],
            client_name="CCCC",
            language='en',
            country_codes=[CountryCode('US')],
            user=LinkTokenCreateRequestUser(
                client_user_id=uid
            )
        )
        print(f'link_token_create_request {request}')

        # Create Link Token Response
        response: plaid_api.LinkTokenCreateResponse = plaid_client.link_token_create(
            request
        )
        print(f'link_token_create response= {response}')

        link_token: str = response['link_token']
        print(f'get_link_token worked! The token = {link_token}')

        jsonified_response = jsonify(link_token=link_token)
        print(f'jsonified_response {jsonified_response}')

        return jsonified_response
    except:
        error_response = make_response(jsonify('An Error Occurred'), 404)

        return error_response
