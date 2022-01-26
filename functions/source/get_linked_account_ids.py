import json
from typing import Dict, List, Union

import flask

from source.configuration import firestore_client


def get_linked_account_ids(request: Union[flask.Request, Dict]):
    try:
        if type(request) is flask.Request:
            data = request.data
            data_dict = json.loads(data)
            uid: str = data_dict['uid']
        else:
            uid: str = request['uid']

        # Get `accountIds` by accessing user doc on Firestore
        user_doc = firestore_client.collection('users').document(uid)
        user_dict = user_doc.get().to_dict()
        linked_account_ids: List[str] = user_dict.get('accountIds')

        return {'user_doc': user_doc, 'account_ids': linked_account_ids, 'uid': uid}
    except Exception as e:
        return {'error': str(e)}
