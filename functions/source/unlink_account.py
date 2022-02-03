import json
from typing import List

import flask
from flask import jsonify

from source.firestore.delete_accounts import delete_accounts
from source.firestore.delete_transactions import delete_transactions
from source.firestore.get_access_token_for_institution import get_access_token_for_institution
from source.item.item_remove import item_remove


def unlink_account(request: flask.Request):
    print('unlinlk_account function started')
    # ^TODO: change the data type to `flask.Request` in release

    request_dict: dict = json.loads(request.data)  # for release
    # request_dict = request  # for sandbox
    uid = request_dict.get('uid')
    institution_id = request_dict.get('institution_id')

    if (uid and institution_id) is None:
        return {'status': 404, 'message': 'Either uid or institution_id null. Please send the request again'}

    #### DELETE accounts associated with the given `institution_id` ####
    delete_accounts_response = delete_accounts(uid, institution_id)
    print(delete_accounts_response)

    # if above function returns error, return that error
    if delete_accounts_response.get('status') == 404:
        return delete_accounts_response

    #### Delete transactions associated with the deleted accounts ####
    metadata: dict = delete_accounts_response.get('metadata')
    account_ids: List[str] = metadata.get('deleted_account_ids')
    delete_transactions_response = delete_transactions(uid, account_ids)
    print(delete_transactions_response)

    access_token_response = get_access_token_for_institution(
        uid, institution_id)
    access_token = access_token_response.get('access_token')

    if access_token is None:
        return access_token_response

    item_remove_response = item_remove(access_token)

    return jsonify(
        status=200,
        delete_accounts_response=delete_accounts_response,
        delete_transactions_response=delete_transactions_response,
        item_remove_response=item_remove_response
    )
