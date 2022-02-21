import json
from datetime import datetime
from typing import Dict, List, Optional

import flask
from flask import jsonify

from endpoints.product_balance_endpoints import accounts_balance_get
from endpoints.product_transactions_endpoints import transactions_get
from firestore.get_access_tokens import get_access_tokens
from firestore.update_accounts import update_accounts
from firestore.update_plaid_secrets import update_plaid_secrets
from firestore.update_transactions import update_transactions


def transactions_refresh(request: flask.Request):
    # TODO: ^change the type of request to `flask.Request`

    data_dict: dict = json.loads(request.data)  # TODO: for release
    # data_dict = request  # TODO: for sandbox
    uid: Optional[str] = data_dict.get('uid')

    #### 1. Get stored access_token and start_date ####
    access_tokens_response = get_access_tokens(uid)
    access_tokens: Optional[List[Dict]
                            ] = access_tokens_response.get('acess_tokens')
    print(access_tokens)

    if access_tokens is None:
        return access_tokens_response
    ####

    access_tokens_status = []

    for response in access_tokens:
        access_token = response.get('access_token')
        institution_id = response.get('institution_id')
        update_status = {}
        update_status['institution_id'] = institution_id

        #### 2. call /transactions/get and update Firestore transactions collections ####
        transacitons_get_response = transactions_get(
            access_token=access_token,
            start_date=response.get('start_date'),
            end_date=datetime.now().date(),
        )
        transactions = transacitons_get_response.get('transactions')

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
        ####

        #### 3. Get /accounts/balance/get and update Firestore accounts collection ####
        balances_get_response = accounts_balance_get(access_token)
        accounts: Optional[List[Dict]] = balances_get_response.get('accounts')

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
        ####

        #### 4. Update plaid_secrets on Firestore ####
        update_plaid_secrets_response = update_plaid_secrets(
            uid, institution_id, transactions)
        update_status['update_plaid_secrets_status'] = update_plaid_secrets_response.get(
            'status')
        update_status['update_plaid_secrets_message'] = update_plaid_secrets_response.get(
            'message')
        ####

        access_tokens_status.append(update_status)

    print(access_tokens_status)

    # TODO: uncomment below for release
    return jsonify(status=200, access_tokens_status=access_tokens_status)
