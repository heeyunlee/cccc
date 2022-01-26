from datetime import datetime
from typing import Any, Dict, List

from source.configuration import firestore_client


def update_user_account_ids(uid: str, accounts: List[Dict[str, Any]]) -> Dict[str, Any]:
    try:
        user_doc = firestore_client.collection('users').document(uid)

        # Update `accountIds` in user document
        new_account_ids: List[str] = [x['account_id'] for x in accounts]
        user_dict = user_doc.get().to_dict()
        old_account_ids: List[str] = user_dict['accountIds']
        combined_ids = list(set(new_account_ids + old_account_ids))
        print(f'Combined IDs {combined_ids}')

        update_result = user_doc.update({
            'accountIds': combined_ids,
            'lastPlaidSnycTime': str(datetime.now()),
        })
        update_result.update_time

        resunt = {
            'status': 200,
            'update_time': update_result.update_time
        }

        return resunt
    except Exception as e:
        result = {
            'status': 404,
            'error_message': str(e),
        }

        return result
