from datetime import datetime
from typing import Any, Dict, List, Union

from google.cloud.firestore_v1.collection import CollectionReference
from plaid.model.account_balance import AccountBalance

from source.configuration import firestore_client


def update_accounts(uid: str, accounts: List[dict]) -> Dict[str, Any]:
    try:
        user_doc = firestore_client.collection('users').document(uid)
        accounts_ref: CollectionReference = user_doc.collection('accounts')

        # Update Accounts in `Accounts` collections
        for account in accounts:
            print(f'account {account}')

            # Update Accounts Collections
            account_id: str = account.get('account_id')
            print(f'accountId {account_id}')

            account_doc_ref = accounts_ref.document(account_id)
            account_snapshot = account_doc_ref.get()
            print(f'account_snapshot {account_snapshot}')

            balances: Union[AccountBalance, None] = account.get('balances')

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
                'last_synced_time': datetime.now()
            }

            if account_snapshot.exists:
                write_result = account_doc_ref.update(data)
                update_time = write_result.update_time
            else:
                write_result = account_doc_ref.set(data)
                update_time = write_result.update_time

            result = {
                'status': 200,
                'last_update_time': update_time,
            }

        return result
    except Exception as e:
        result = {
            'status': 404,
            'error_message': str(e),
        }

        return result
