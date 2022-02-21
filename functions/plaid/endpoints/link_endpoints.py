import json
from typing import Dict, List, Optional

import flask
from firestore.update_accounts import update_accounts
from firestore.update_accounts_connection_state import update_accounts_connection_state
from firestore.update_user_secrets import update_user_secrets
from flask import jsonify

from endpoints.product_balance_endpoints import accounts_balance_get
from endpoints.token_endpoints import public_token_exchange

''' Link and Connect

    After a user connect a bank account and gets the `public_token`,
    this function is called to 
    1. Exchange `public_token` to `access_token`
    2. Using the `access_token`, call /accounts/balance/get
    3. Using the accounts info, update Firebase Firestore database
'''


def link_and_connect(request: flask.Request):
    # TODO: ^change the data type to flask.Request

    data_dict: dict = json.loads(request.data)  # TODO: for release
    # data_dict = request # TODO: for sandbox
    public_token: Optional[str] = data_dict.get('public_token')
    uid: Optional[str] = data_dict.get('uid')
    institution_id: Optional[str] = data_dict.get('institution_id')

    if (uid and institution_id) is None:
        return jsonify(status=404, error_message='Please pass the right data in request')

    # 1. Get access_token by using `item_public_token_exchange`
    token_exchange_response = public_token_exchange(public_token)
    # TODO: change the data passed from `institution_id` to `public_token`

    access_token = token_exchange_response.get('access_token')
    print(f'Got access_token: {access_token}')

    # If access_token is None, return error
    if access_token is None:
        error_code = token_exchange_response.get('error_code')
        error_message = token_exchange_response.get('error_message')
        print(f'Error code: {error_code}')
        print(f'Error message: {error_message}')

        # TODO: uncomment below for release
        return jsonify(status=error_code, error_message=error_message)

    # 2. Else, call /accounts/balance/get
    balances_get_response = accounts_balance_get(access_token)
    accounts: Optional[List[Dict]] = balances_get_response.get('accounts')
    print(f'balances got: {balances_get_response}')

    # If accounts is None, return error
    if accounts is None:
        error_code = balances_get_response.get('error_code')
        error_message = balances_get_response.get('error_message')
        print(f'Error code: {error_code}')
        print(f'Error message: {error_message}')

        # TODO: uncomment below for release
        return jsonify(status=error_code, error_message=error_message)

    # 3. Update [Account] collection if hot accounts
    print(f'Got {len(accounts)} of accounts')
    update_account_result = update_accounts(uid, institution_id, accounts)

    # 4. Update user's secret keys with new access_token
    update_plaid_tokens_result = update_user_secrets(
        uid, access_token, institution_id)

    print(f'''
        update_account_result: {update_account_result}s
        update_plaid_tokens_result: {update_plaid_tokens_result}
    ''')

    # TODO: uncomment below for release
    return jsonify(
        update_account_result=update_account_result,
        update_plaid_tokens_result=update_plaid_tokens_result,
    )


def link_and_connect_update_mode(request: flask.Request):
    # TODO: for release

    # Parsing data from request to get `uid` and `public_token`
    data_dict: dict = json.loads(request.data)
    public_token: Optional[str] = data_dict.get('public_token')
    uid: Optional[str] = data_dict.get('uid')
    institution_id: Optional[str] = data_dict.get('institution_id')

    if (public_token and uid and institution_id) is None:
        return jsonify(error_code=404, error_message='Please pass the right data in request')

    # 1. Get access_token by using `item_public_token_exchange`
    token_exchange_response = public_token_exchange(public_token)
    # TODO: ^change the data passed from `institution_id` to `public_token`
    print(f'token_exchange_response: {token_exchange_response}')

    access_token = token_exchange_response.get('access_token')

    # If access_token is None, return error
    if access_token is None:
        error_code = token_exchange_response.get('error_code')
        error_message = token_exchange_response.get('error_message')
        print(f'Error code: {error_code}')
        print(f'Error message: {error_message}')

        # TODO: uncomment below for release
        return jsonify(error_code=error_code, error_message=error_message)

    # 2. Else, call /accounts/balance/get
    balances_get_response = accounts_balance_get(access_token)
    accounts: Optional[List[Dict]] = balances_get_response.get('accounts')
    print(f'balances got: {balances_get_response}')

    # If accounts is None, return error
    if accounts is None:
        error_code = balances_get_response.get('error_code')
        error_message = balances_get_response.get('error_message')
        print(f'Error code: {error_code}')
        print(f'Error message: {error_message}')

        # TODO: uncomment below for release
        return jsonify(error_code=error_code, error_message=error_message)

    # 3. Update [Account] collection if hot accounts
    print(f'Got {len(accounts)} of accounts')
    update_account_result = update_accounts_connection_state(
        uid, institution_id)

    return update_account_result
