from google.cloud.firestore import CollectionReference

from firestore.cloud_firestore import CloudFirestore, FirestoreEnv


def delete_accounts(uid: str, institution_id: str):

    try:
        delete_account_ids = []

        # TODO: Change Environment for production for release
        firestore = CloudFirestore(FirestoreEnv.PRODUCTION)
        client = firestore.client()

        user_ref = client.collection('users').document(uid)
        accounts_ref: CollectionReference = user_ref.collection('accounts')
        accounts_query = accounts_ref.where(
            'institution_id', '==', institution_id).stream()

        for account in accounts_query:
            account_id = account.id
            account_doc_ref = accounts_ref.document(account_id)
            account_doc_ref.delete()
            delete_account_ids.append(account_id)

        return {
            'status': 200,
            'message': f'Successfully deleted {len(delete_account_ids)} accounts',
            'metadata': {'deleted_account_ids': delete_account_ids}
        }
    except Exception as e:
        return {'status': 404, 'error_message': str(e)}
