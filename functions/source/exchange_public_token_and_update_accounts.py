import json
from typing import Union

import flask
from flask import jsonify, make_response

from source.accounts_get import accounts_get
from source.exchange_public_token import exchange_public_token
from source.update_accounts import update_accounts
from source.update_plaid_keys import update_plaid_keys
from source.update_user_account_ids import update_user_account_ids


def exchange_public_token_and_update_accounts(request: Union[flask.Request, dict]):

    # Parsing data from request
    if type(request) is not dict:
        data = request.data
        data_dict: dict = json.loads(data)
    else:
        data_dict = request

    uid: str = data_dict.get('uid')

    """ 
    Exchange public_token to access_token. 
    Returns 
        `access_token` if successful
        `None` if NOT successful
    """
    exchange_public_token_response = exchange_public_token(False, data_dict)
    access_token = exchange_public_token_response.get('access_token')
    print(f'Got access_token: {access_token}')

    # if `access_token` exists, keep going
    if access_token is not None:

        """
        Find the accounts corresponding to the access_token
        Returns
            'List[dict]' if successful
            `dict` if NOT successful with error_code
        """
        accounts = accounts_get(access_token)

        if type(accounts) == dict:
            error_code = accounts.get('error_code')
            error_message = accounts.get('error_message')
            print(f'Got error. {accounts}')

            result = jsonify(error_code=error_code,
                             error_message=error_message)

            return make_response(result, 404)
        else:
            account_ids = [x.get('account_id') for x in accounts]
            print(f'Linked accounts: {account_ids}')

            update_account_result = update_accounts(uid, accounts)
            print(f'update_account_result: {update_account_result}')

            update_user_result = update_user_account_ids(uid, accounts)
            print(f'update_user_result: {update_user_result}')

            update_keys_result = update_plaid_keys(uid, access_token)
            print(f'update_keys_result: {update_keys_result}')

            status_1 = update_account_result.get('status')
            status_2 = update_user_result.get('status')
            status_3 = update_keys_result.get('status')

            if status_1 == 200 and status_2 == 200 and status_3 == 200:
                return make_response(jsonify(status=200), 200)
            else:
                return make_response(jsonify(status=404), 404)

    # if `access_token` is None, returns the error
    else:
        error_code = exchange_public_token_response.get('error_code')
        error_message = exchange_public_token_response.get('error_message')
        print(f'Got error. {exchange_public_token_response}')

        result = jsonify(error_code=error_code, error_message=error_message)

        return make_response(result, 404)
