import json
from typing import Dict, List, Optional

import flask
from flask import jsonify

from source.balance.accounts_balance_get import accounts_balance_get
from source.firestore.update_accounts_connection_state import update_accounts_connection_state
from source.token.public_token_exchange import public_token_exchange


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
