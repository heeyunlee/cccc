import json
from typing import Any, Dict, Union

import flask
from plaid import ApiException
from plaid.api import plaid_api
from plaid.model.country_code import CountryCode
# from plaid.model.link_token_create_request_user import \
#     LinkTokenCreateRequestUser
# from plaid.model.products import Products

# from source.configuration import plaid_client

# ''' /institutions/get_by_id

#     Returns a JSON response containing details on a specified financial institution currently
#     upported by Plaid.

#     Versioning note: API versions 2019-05-29 and earlier allow use of the public_key parameter
#     instead of the client_id and secret to authenticate to this endpoint. The public_key has been
#     deprecated; all customers are encouraged to use client_id and secret instead.
# '''
# def institutions_get_by_id(request: flask.Request):
