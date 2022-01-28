import json
from typing import Dict, List, Union

import flask
from flask import jsonify, make_response

from source.balance.accounts_balance_get import accounts_balance_get
from source.firestore.update_accounts import update_accounts
from source.firestore.update_user_secrets import update_user_secrets
from source.token.public_token_exchange import public_token_exchange

''' Link and Connect

    After a user connect a bank account and gets the `public_token`,
    this function is called to 
    1. Exchange `public_token` to `access_token`
    2. Using the `access_token`, call /accounts/balance/get
    3. Using the accounts info, update Firebase Firestore database
'''


def link_and_connect(request: flask.Request):
    # TODO: ^change the type of request to `flask.Request`

    # TODO: uncomment below for release
    # Parsing data from request to get `uid` and `public_token`
    data = request.data
    data_dict: dict = json.loads(data)
    public_token: Union[str, None] = data_dict.get('public_token')
    uid: Union[str, None] = data_dict.get('uid')

    # TODO: pass `public_token` for release instead of request
    # 1. Get access_token by using `item_public_token_exchange`
    token_exchange_response = public_token_exchange(public_token)
    access_token = token_exchange_response.get('access_token')
    print(f'Got access_token: {access_token}')

    # If access_token is None, return error
    if access_token is None:
        error_code = token_exchange_response.get('error_code')
        error_message = token_exchange_response.get('error_message')
        print(f'Error code: {error_code}')
        print(f'Error message: {error_message}')

        # TODO: uncomment below for release
        return make_response(jsonify(status=error_code, error_message=error_message), 404)

    # 2. Else, call /accounts/balance/get
    balances_get_response = accounts_balance_get(access_token)
    accounts: Union[List[Dict], None] = balances_get_response.get('accounts')
    print(f'balances got: {balances_get_response}')

    # If accounts is None, return error
    if accounts is None:
        error_code = balances_get_response.get('error_code')
        error_message = balances_get_response.get('error_message')
        print(f'Error code: {error_code}')
        print(f'Error message: {error_message}')

        # TODO: uncomment below for release
        return make_response(jsonify(status=error_code, error_message=error_message), 404)

    # 3. Update [Account] collection if hot accounts
    print(f'Got {len(accounts)} of accounts')

    item: Union[Dict, None] = balances_get_response.get('item')
    institution_id: Union[str, None] = item.get('institution_id')
    update_account_result = update_accounts(uid, institution_id, accounts)
    print(f'update_account_result: {update_account_result}')

    # 4. Update user's secret keys with new access_token
    update_plaid_tokens_result = update_user_secrets(uid, access_token)
    print(f'update_plaid_tokens_result: {update_plaid_tokens_result}')

    # Get the status of these two firestore updates, and return
    update_account_status = update_account_result.get('status')
    update_access_token_status = update_plaid_tokens_result.get('status')
    print(f'''
        update_account_status: {update_account_status}
        update_access_token_status: {update_access_token_status}
    ''')

    # TODO: uncomment below for release
    result = jsonify(
        status=200,
        update_account=update_account_status,
        update_access_token=update_access_token_status,
    )

    return make_response(result)
