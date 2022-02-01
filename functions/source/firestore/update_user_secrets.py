from typing import Any, Dict

from google.cloud.firestore import CollectionReference
from google.cloud import firestore


def update_user_secrets(uid: str, access_token: str, institution_id: str) -> Dict[str, Any]:
    try:
        client = firestore.Client()
        user_doc = client.collection('users').document(uid)
        secrets_collection: CollectionReference = user_doc.collection(
            'secrets')
        plaid_secret_doc_ref = secrets_collection.document('plaid')
        plaid_secret_snapshot = plaid_secret_doc_ref.get()

        new_access_token_dict = {institution_id: access_token}

        if plaid_secret_snapshot.exists:
            secret_doc = plaid_secret_snapshot.to_dict()
            access_token_dict: Dict[str, str] = secret_doc.get('access_tokens')
            print(f'old access tokens: {access_token_dict}')

            access_token_dict[institution_id] = access_token
            print(f'new access tokens {access_token_dict}')

            plaid_secret_doc_ref.update({'access_tokens': access_token_dict})
        else:
            plaid_secret_doc_ref.create(
                {'access_tokens': new_access_token_dict})

        result = {
            'status': 200,
            'message': 'Successfully updated access_tokens',
        }

        return result
    except Exception as e:
        result = {
            'status': 404,
            'message': str(e),
        }

        return result
