import datetime
import json
from datetime import timedelta
from typing import Any, Dict, List, Union

import flask
import plaid
from flask import jsonify, make_response
from google.cloud import firestore
from google.cloud.firestore import CollectionReference, DocumentReference
from plaid import ApiException
from plaid.api import plaid_api
from plaid.model.account_balance import AccountBalance
from plaid.model.accounts_get_request import AccountsGetRequest
from plaid.model.accounts_get_response import AccountsGetResponse
from plaid.model.country_code import CountryCode
from plaid.model.item_public_token_exchange_request import \
    ItemPublicTokenExchangeRequest
from plaid.model.item_public_token_exchange_response import \
    ItemPublicTokenExchangeResponse
from plaid.model.link_token_create_request_user import \
    LinkTokenCreateRequestUser
from plaid.model.products import Products
from plaid.model.sandbox_public_token_create_request import \
    SandboxPublicTokenCreateRequest
from plaid.model.sandbox_public_token_create_response import \
    SandboxPublicTokenCreateResponse
from plaid.model.transaction import Transaction
from plaid.model.transactions_get_request_options import \
    TransactionsGetRequestOptions
from plaid.model.transactions_get_response import TransactionsGetResponse
