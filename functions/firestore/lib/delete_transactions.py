# from typing import List

# from google.cloud.firestore import CollectionReference

# from cloud_firestore import CloudFirestore, FirestoreEnv


# def delete_transactions(uid: str, account_ids: List[str]):
#     try:
#         deleted_transaction_ids = []

#         # TODO: Change Environment for production for release
#         firestore = CloudFirestore(FirestoreEnv.PRODUCTION)
#         client = firestore.client()

#         user_ref = client.collection('users').document(uid)
#         transactions_ref: CollectionReference = user_ref.collection(
#             'transactions')
#         transactions_query = transactions_ref.where(
#             'account_id', 'in', account_ids).stream()

#         for transaction in transactions_query:
#             transaction_id = transaction.id
#             transaction_doc_ref = transactions_ref.document(transaction_id)
#             transaction_doc_ref.delete()
#             deleted_transaction_ids.append(transaction_id)

#         return {
#             'status': 200,
#             'message': f'Successfully deleted {len(deleted_transaction_ids)} accounts',
#             'metadata': {'deleted_account_ids': deleted_transaction_ids}
#         }
#     except Exception as e:
#         return {'status': 404, 'error_message': str(e)}
