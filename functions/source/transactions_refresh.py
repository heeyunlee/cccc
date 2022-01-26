import json

import flask
from flask import jsonify, make_response
from plaid import ApiException
from plaid.model.transactions_get_response import TransactionsGetResponse

from source.configuration import plaid_client
from source.create_transactions_get_request import \
    create_transactions_get_request
from source.get_linked_account_ids import get_linked_account_ids
from source.update_accounts import update_accounts
from source.update_transactions import update_transactions


def transactions_refresh(request: flask.Request or dict):

    get_account_ids = get_linked_account_ids(request)

    account_ids = get_account_ids.get('account_ids')
    print(f'Account IDs {account_ids}')

    user_doc = get_account_ids.get('user_doc')
    uid = get_account_ids.get('uid')

    if account_ids is None:
        return make_response(jsonify(error=get_account_ids.get('error')), 404)

    print(f'account_ids {account_ids}')

    fetched_tranactions = 0
    fetched_accounts = 0

    for account_id in account_ids:
        transactions_get_request = create_transactions_get_request(
            user_doc, account_id)
        print(f'request {transactions_get_request}')

        try:
            transactions_get_response: TransactionsGetResponse = plaid_client.transactions_get(
                transactions_get_request
            )
            response_dict = transactions_get_response.to_dict()

            #### Update or Create Transactions Data ####
            transactions = response_dict.get('transactions')
            print(f'Retrieved {len(transactions)} transactions')
            fetched_tranactions += len(transactions)

            accounts = response_dict.get('accounts')
            fetched_accounts += len(accounts)
            print(f'Retrieved {len(accounts)} Accounts')

            #### Update transactions ####
            update_transactions_result = update_transactions(uid, transactions)
            print(f'Update Transactions: {update_transactions_result}')

            #### Update accounts ####
            update_accounts_result = update_accounts(uid, accounts)
            print(f'Update Accounts: {update_accounts_result}')

            transactions_status = update_transactions_result.get('status')
            accounts_status = update_accounts_result.get('status')
            exceptions = None

        except ApiException as e:
            exceptions: dict = json.loads(e.body)
            transactions_status, accounts_status = 404

    result = {
        'transactions_status': transactions_status,
        'accounts_status': accounts_status,
        'fetched_transactions': fetched_tranactions,
        'fetched_accounts': fetched_accounts,
        'exceptions': exceptions,
    }

    return make_response(result, accounts_status)
