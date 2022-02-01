from google.cloud import firestore
from google.cloud.firestore import CollectionReference


def update_accounts_connection_state(uid: str, institution_id: str):
    try:
        client = firestore.Client()
        user_doc = client.collection('users').document(uid)
        accounts_collections: CollectionReference = user_doc.collection(
            'accounts')

        accounts_query = accounts_collections.where(
            'institution_id', '==', institution_id)
        accounts_stream = accounts_query.stream()

        for account in accounts_stream:
            account_doc = account.to_dict()
            account_id = account_doc.get('account_id')
            account_ref = accounts_collections.document(account_id)
            data = {
                'account_connection_state': 'healthy',
            }

            account_ref.update(data)

        result = {
            'status': 200,
            'error_message': 'Successfully updated account connection state',
        }

        return result
    except Exception as e:
        result = {
            'status': 404,
            'error_message': str(e),
        }

        return result
