from typing import Any, Dict

from google.cloud.firestore import DocumentReference
from source.configuration import firestore_client


def get_access_tokens(uid: str) -> Dict[str, Any]:
    user_doc = firestore_client.collection('users').document(uid)
    user_secrets_doc: DocumentReference = user_doc.collection(
        'secrets').document(uid)
    user_secrets_snapshot = user_secrets_doc.get()

    if not user_secrets_snapshot.exists:
        return {'status': 400, 'error_message': 'access token does not exists'}

    access_tokens = user_secrets_snapshot.to_dict().get('plaid_access_tokens')

    return {'status': 200, 'acess_tokens': access_tokens}
