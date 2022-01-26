from typing import Any, Dict

from google.cloud.firestore_v1.collection import CollectionReference

from source.configuration import firestore_client


def update_plaid_keys(uid: str, access_token: str) -> Dict[str, Any]:
    try:
        user_doc = firestore_client.collection('users').document(uid)
        plaid_keys_collection: CollectionReference = user_doc.collection(
            'plaid_keys')
        plaid_keys_doc = plaid_keys_collection.document('private_keys')

        plaid_keys_dict = plaid_keys_doc.get().to_dict()

        if plaid_keys_dict is None:
            write_result = plaid_keys_doc.create({
                'access_token': access_token,
            })
            update_time = write_result.update_time
        else:
            write_result = plaid_keys_doc.update({
                'access_token': access_token,
            })
            update_time = write_result.update_time

        result = {
            'status': 200,
            'last_update_time': update_time,
        }

        return result
    except Exception as e:
        result = {
            'status': 404,
            'error': str(e),
        }
        return result
