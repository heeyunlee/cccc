from google.cloud import firestore
from constants.constants import food_category_id_list


def update_transactions_is_food(data, context):
    print(f'''
    update_transactions_data data={data}
    update_transactions_data context={context}
    ''')

    # Get Transaction document from Firestore
    path_parts = context.resource.split('/documents/')[1].split('/')
    collection_path = path_parts[0]
    document_path = '/'.join(path_parts[1:])

    client = firestore.Client()
    users_collection = client.collection(collection_path)
    transactions_doc = users_collection.document(document_path)

    # Get Transaction Data
    transactions_dict = transactions_doc.get().to_dict()
    print('transactions_dict:', transactions_dict)

    # Transaction Category Id
    category_id = transactions_dict['category_id']

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
