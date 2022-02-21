from datetime import datetime
from typing import Any, Dict, List, Optional

from google.cloud.firestore_v1.collection import CollectionReference
from plaid.model.account_balance import AccountBalance

from firestore.cloud_firestore import CloudFirestore, FirestoreEnv


def update_accounts(uid: str, institution_id: str, accounts: Optional[List[Dict]]) -> Dict[str, Any]:

    try:
        # TODO: Change Environment for production for release
        firestore = CloudFirestore(FirestoreEnv.PRODUCTION)
        client = firestore.client()

        user_doc = client.collection('users').document(uid)
        accounts_collections: CollectionReference = user_doc.collection(
            'accounts')

        if accounts is None:
            accounts_query = accounts_collections.where(
                'institution_id', '==', institution_id)
            accounts_stream = accounts_query.stream()

            for account in accounts_stream:
                account_doc = account.to_dict()
                account_id = account_doc.get('account_id')
                account_ref = accounts_collections.document(account_id)
                data = {
                    'account_connection_state': 'error',
                }

                account_ref.update(data)
        else:
            # Update Accounts in `Accounts` collections
            for account in accounts:

                # Update Accounts Collections
                account_id: str = account.get('account_id')
                print(f'accountId: {account_id}')

                account_doc_ref = accounts_collections.document(account_id)
                account_snapshot = account_doc_ref.get()

                balances: Optional[AccountBalance] = account.get('balances')

                data = {
                    'account_id': account.get('account_id'),
                    'balances': {
                        'available': balances.get('available'),
                        'current': balances.get('current'),
                        'iso_currency_code': balances.get('iso_currency_code'),
                        'limit': balances.get('limit'),
                        'unofficial_currency_code': balances.get('unofficial_currency_code'),
                    },
                    'mask': account.get('mask'),
                    'name': account.get('name'),
                    'official_name': account.get('official_name'),
                    'subtype': str(account.get('subtype')),
                    'type': str(account.get('type')),
                    'verification_status': account.get('verification_status'),
                    'account_last_synced_time': datetime.now(),
                    'institution_id': institution_id,
                    'account_connection_state': 'healthy'
                }

                if account_snapshot.exists:
                    account_doc_ref.update(data)
                else:
                    account_doc_ref.set(data)

                result = {
                    'status': 200,
                    'message': 'successfully updated accounts data',
                }

        return result
    except Exception as e:
        result = {
            'status': 404,
            'error_message': str(e),
        }

        return result
