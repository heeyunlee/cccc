from typing import Dict, Union

from google.cloud import firestore
from google.cloud.firestore import CollectionReference


def get_access_token_for_institution(uid: str, institution_id: str):
    try:
        client = firestore.Client()
        user_ref = client.collection('users').document(uid)
        secrets_ref: CollectionReference = user_ref.collection('secrets')
        plaid_secrets_ref = secrets_ref.document('plaid')
        plaid_secrets_dict = plaid_secrets_ref.get().to_dict()
        access_tokens: Union[Dict, None] = plaid_secrets_dict.get(
            'access_tokens')
        access_token = access_tokens.get(institution_id)

        return {'status': 200, 'access_token': access_token}
    except Exception as e:
        return {'status': 404, 'error_message': str(e)}
