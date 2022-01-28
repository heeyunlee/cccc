import json
from datetime import datetime, timedelta
from typing import Dict, List, Union

import flask
from flask import jsonify, make_response

from source.balance.accounts_balance_get import accounts_balance_get
from source.firestore.get_access_tokens import get_access_tokens
from source.firestore.update_accounts import update_accounts
from source.firestore.update_transactions import update_transactions
from source.transactions.transactions_get import transactions_get


def transactions_refresh(request: flask.Request):
    # TODO: ^change the type of request to `flask.Request`

    # TODO: uncomment below for release
    # Parsing data from request to get `uid`
    data = request.data
    data_dict: dict = json.loads(data)
    uid: Union[str, None] = data_dict.get('uid')

    now = datetime.now()
    end_date = now.date()
    start_date = (now - timedelta(60)).date()

    # Get stored access_tokens
    access_tokens_response = get_access_tokens(uid)
    access_tokens: Union[List[str], None] = access_tokens_response.get(
        'acess_tokens'
    )
    print(f'access_tokens: {access_tokens}')

    if access_tokens is None:
        return access_tokens_response

    for access_token in access_tokens:
        transacitons_get_response = transactions_get(
            access_token=access_token,
            start_date=start_date,
            end_date=end_date,
        )

        # Get Transactions data and update Firestore transactions collection
        transactions: Union[List[Dict], None] = transacitons_get_response.get(
            'transactions')

        if transactions is None:
            error_code = transacitons_get_response.get('error_code')
            error_message = transacitons_get_response.get('error_message')
            print(f'Error code: {error_code}')
            print(f'Error message: {error_message}')

            # TODO: uncomment below for release
            return make_response(jsonify(status=error_code, error_message=error_message), 404)

        print(f'Fetched {len(transactions)} transaction(s)')
        update_transactions_result = update_transactions(uid, transactions)
        print(f'update_transactions_result: {update_transactions_result}')

        # Get /accounts/balance/get and update Firestore accounts collection
        balances_get_response = accounts_balance_get(access_token)
        accounts: Union[List[Dict],
                        None] = balances_get_response.get('accounts')

        if accounts is None:
            error_code = balances_get_response.get('error_code')
            error_message = balances_get_response.get('error_message')
            print(f'Error code: {error_code}')
            print(f'Error message: {error_message}')

            # TODO: uncomment below for release
            return make_response(jsonify(status=error_code, error_message=error_message), 404)

        item: Union[Dict, None] = balances_get_response.get('item')
        institution_id: Union[str, None] = item.get('institution_id')
        update_account_result = update_accounts(uid, institution_id, accounts)
        print(f'update_account_result: {update_account_result}')

        # Get the status of these two firestore updates, and return
        update_transactions_status = update_transactions_result.get('status')
        update_account_result_status = update_account_result.get('status')
        print(f'''
            update_transactions_status: {update_transactions_status}
            update_account_result_status: {update_account_result_status}
        ''')

    # TODO: uncomment below for release
    result = jsonify(
        update_transactions_status=update_transactions_status,
        update_account_result_status=update_account_result_status,
    )

    return make_response(result)
