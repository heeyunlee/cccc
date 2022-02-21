from cloud_firestore import CloudFirestore, FirestoreEnv
from google.cloud.functions_v1.context import Context

from lib.food_categories import food_category_id_list


def update_transaction_is_food(data: dict, context: Context):
    try:
        # Get Transaction document from Firestore
        path_parts = context.resource.split('/documents/')[1].split('/')
        collection_path = path_parts[0]
        document_path = '/'.join(path_parts[1:])

        # TODO: Change Environment for production for release
        firestore = CloudFirestore(FirestoreEnv.PRODUCTION)
        client = firestore.client()

        users_collection = client.collection(collection_path)
        transactions_doc = users_collection.document(document_path)

        # Get Transaction Data
        transactions_dict = transactions_doc.get().to_dict()
        print('transactions_dict:', transactions_dict)

        # Transaction Category Id
        category_id = transactions_dict.get('category_id')

        # Update Transaction is_food_category field
        if category_id in food_category_id_list:
            print('Transaction is a food category')

            transactions_dict.update({
                'is_food_category': True,
            })
        else:
            print('Transaction is NOT a food category')

            transactions_dict.update({
                'is_food_category': False,
            })

        # Update Transaction Data
        transactions_doc.update(transactions_dict)
        print('Successfully updated transaction data')

        return {'status': 200, 'message': 'Successfully updated transaction data'}
    except Exception as e:
        return {'status': 404, 'message': str(e)}
