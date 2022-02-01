from typing import Any, Dict

from google.cloud import firestore
from google.cloud.firestore import CollectionReference


def get_access_tokens(uid: str) -> Dict[str, Any]:
    try:
        client = firestore.Client()
        user_doc = client.collection('users').document(uid)
        secrets_ref: CollectionReference = user_doc.collection('secrets')
        plaid_secrets_ref = secrets_ref.document('plaid')
        plaid_secrets_dict = plaid_secrets_ref.get().to_dict()
        access_tokens = plaid_secrets_dict.get('access_tokens')

        return {'status': 200, 'acess_tokens': access_tokens}
    except Exception as e:
        return {'status': 404, 'error_message': str(e)}
