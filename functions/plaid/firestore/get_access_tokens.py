from datetime import datetime, timedelta
from typing import Optional

from google.cloud.firestore import CollectionReference

from firestore.cloud_firestore import CloudFirestore, FirestoreEnv


def get_access_tokens(uid: str):
    try:
        access_tokens = []

        # TODO: Change Environment for production for release
        firestore = CloudFirestore(FirestoreEnv.PRODUCTION)
        client = firestore.client()

        user_doc = client.collection('users').document(uid)
        secrets_ref: CollectionReference = user_doc.collection('plaid_secrets')
        secrets = secrets_ref.stream()

        for secret in secrets:
            result = {}
            result['institution_id'] = secret.id
            result['access_token'] = secret.get('access_token')

            start_date: Optional[datetime] = secret.to_dict().get(
                'first_pending_transaction_date')

            if start_date is None:
                start_date = (datetime.now() - timedelta(90)).date()
            else:
                start_date = start_date.date()

            result['start_date'] = start_date

            access_tokens.append(result)

        return {'status': 200, 'acess_tokens': access_tokens}
    except Exception as e:
        return {'status': 404, 'error_message': str(e)}
