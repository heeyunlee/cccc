import json

import flask
from flask import jsonify, make_response
from plaid.model.item_public_token_exchange_request import \
    ItemPublicTokenExchangeRequest
from plaid.model.item_public_token_exchange_response import \
    ItemPublicTokenExchangeResponse

from source.configuration import firestore_client, plaid_client


def exchange_public_token(request: flask.Request) -> dict:
    try:
        data = request.get_data()
        print(f'data is {data}')

        data_decoded = data.decode('UTF-8')
        data_dict = json.loads(data_decoded)
        public_token = data_dict['public_token']
        uid = data_dict['uid']
        account_ids: list = data_dict['account_ids']

        print(f'Account IDs are {account_ids}')

        request = ItemPublicTokenExchangeRequest(public_token=public_token)
        response: ItemPublicTokenExchangeResponse = plaid_client.item_public_token_exchange(
            request
        )
        print(f'response is: {response.to_dict()}')

        affected_doc = firestore_client.collection('users').document(uid)
        user_doct: list = affected_doc.get().to_dict()
        old_accounts_ids = user_doct['accountsIds']
        print(f'old_accounts_ids is: {old_accounts_ids}')

        new_account_ids = account_ids + old_accounts_ids

        access_token = response.access_token
        item_id = response.item_id
        request_id = response.request_id

        affected_doc.update({
            'plaidAccessToken': access_token,
            'plaidItemId': item_id,
            'plaidRequestId': request_id,
            'accountIds': new_account_ids,
        })

        success_response = make_response(
            jsonify('Successfully updated user doc'), 200
        )

        return success_response
    except:
        error_response = make_response(jsonify('An Error Occurred'), 404)

        return error_response
