from typing import Any, Dict

from google.cloud.firestore import CollectionReference

from cloud_firestore import CloudFirestore, FirestoreEnv


def update_user_secrets(uid: str, access_token: str, institution_id: str) -> Dict[str, Any]:
    try:
        # TODO: Change Environment for production for release
        firestore = CloudFirestore(FirestoreEnv.PRODUCTION)
        client = firestore.client()

        user_doc = client.collection('users').document(uid)
        secrets_collection: CollectionReference = user_doc.collection(
            'plaid_secrets')
        institution_secret_ref = secrets_collection.document(institution_id)
        institution_secret_snapshot = institution_secret_ref.get()

        if institution_secret_snapshot.exists:
            institution_secret_ref.update({'access_token': access_token})
        else:
            institution_secret_ref.create({'access_token': access_token})

        result = {
            'status': 200,
            'message': 'Successfully updated access_tokens',
        }

        return result
    except Exception as e:
        return {'status': 404, 'error': str(e)}
