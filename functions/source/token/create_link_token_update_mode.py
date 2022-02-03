import json
from typing import Any, Dict

import flask
from plaid import ApiException
from plaid.api import plaid_api
from plaid.model.country_code import CountryCode
from plaid.model.link_token_create_request_user import LinkTokenCreateRequestUser
from source.configuration import plaid_client
from source.firestore.get_access_token_for_institution import get_access_token_for_institution


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
        # Create Link Token Request
        request = plaid_api.LinkTokenCreateRequest(
            client_name='CCCC',
            language='en',
            access_token=access_token,
            country_codes=[CountryCode('US')],
            user=LinkTokenCreateRequestUser(client_user_id=uid)
        )
        response: plaid_api.LinkTokenCreateResponse = plaid_client.link_token_create(
            request)

        return response.to_dict()
    except ApiException as e:
        return json.loads(e.body)
