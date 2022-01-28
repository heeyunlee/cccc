from typing import Any, Dict, List

from google.cloud.firestore import CollectionReference
from source.configuration import firestore_client


def update_user_secrets(uid: str, access_token: str) -> Dict[str, Any]:
    try:
        user_doc = firestore_client.collection('users').document(uid)
        secrets_collection: CollectionReference = user_doc.collection(
            'secrets')
        user_secret_doc_ref = secrets_collection.document(uid)
        user_secret_doc_snapshot = user_secret_doc_ref.get()

        if user_secret_doc_snapshot.exists:
            secret_doc = user_secret_doc_snapshot.to_dict()
            access_tokens: List[str] = secret_doc.get('plaid_access_tokens')
            print(f'old access tokens: {access_tokens}')

            access_tokens.append(access_token)
            print(f'new access tokens {access_tokens}')

            user_secret_doc_ref.update({'plaid_access_tokens': access_tokens})
        else:
            user_secret_doc_ref.create({'plaid_access_tokens': [access_token]})

        result = {
            'status': 200,
            'message': 'Successfully updated access_tokens',
        }

        return result
    except Exception as e:
        result = {
            'status': 404,
            'error': str(e),
        }

        return result
