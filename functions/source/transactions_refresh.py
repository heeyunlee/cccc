import json
from datetime import datetime, timedelta
from typing import Dict, List, Union

import flask
from flask import make_response, jsonify

from source.balance.accounts_balance_get import accounts_balance_get
from source.firestore.get_access_tokens import get_access_tokens
from source.firestore.update_accounts import update_accounts
from source.firestore.update_transactions import update_transactions
from source.transactions.transactions_get import transactions_get


def transactions_refresh(request: flask.Request):
    # TODO: ^change the type of request to `flask.Request`

    # TODO: uncomment below for release
    # Parsing data from request to get `uid` and `public_token`
    data_dict: dict = json.loads(request.data)
    uid: Union[str, None] = data_dict.get('uid')

    # uid: Union[str, None] = request.get('uid')  # for sandbox
    now = datetime.now()
    end_date = now.date()
    start_date = (now - timedelta(60)).date()

    # Get stored access_tokens
    access_tokens_response = get_access_tokens(uid)
    access_tokens: Union[Dict[str, str],
                         None] = access_tokens_response.get('acess_tokens')
    print(f'access_tokens: {access_tokens}')

    if access_tokens is None:
        return access_tokens_response

    access_tokens_status = []

    for institution_id, access_token in access_tokens.items():
        print(f'code for {institution_id} started')

        update_status = {}
        update_status['institution_id'] = institution_id

        transacitons_get_response = transactions_get(
            access_token=access_token,
            start_date=start_date,
            end_date=end_date,
        )

        # Get Transactions data and update Firestore transactions collection
        transactions = transacitons_get_response.get('transactions')

        # If transaction is None, add the error
        if transactions is None:
            update_status['transactions_get_status'] = transacitons_get_response.get(
                'error_code')
            update_status['transactions_get_message'] = transacitons_get_response.get(
                'error_message')
        else:
            update_status['transactions_get_status'] = 200
            update_status[
                'transactions_get_message'] = f'Successfully got {len(transactions)} transactions'

        update_transactions_result = update_transactions(uid, transactions)
        update_status['transaction_update_status'] = update_transactions_result.get(
            'status')
        update_status['transaction_update_message'] = update_transactions_result.get(
            'message')

        # Get /accounts/balance/get and update Firestore accounts collection
        balances_get_response = accounts_balance_get(access_token)
        accounts: Union[List[Dict],
                        None] = balances_get_response.get('accounts')

        # If transaction is None, add the error
        if accounts is None:
            update_status['accounts_get_status'] = balances_get_response.get(
                'error_code')
            update_status['accounts_get_message'] = balances_get_response.get(
                'error_message')
        else:
            update_status['accounts_get_status'] = 200
            update_status['accounts_get_message'] = f'Successfully got {len(accounts)} accounts'

        update_account_result = update_accounts(uid, institution_id, accounts)
        update_status['accounts_update_status'] = update_account_result.get(
            'status')
        update_status['accounts_update_message'] = update_account_result.get(
            'message')

        access_tokens_status.append(update_status)

    print(access_tokens_status)

    # TODO: uncomment below for release
    return jsonify(access_tokens_status=access_tokens_status)
