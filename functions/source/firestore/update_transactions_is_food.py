from source.configuration import firestore_client

food_category_id_list = [
    '13000000',
    '13001000',
    '13001001',
    '13001002',
    '13001003',
    '13002000',
    '13003000',
    '13004000',
    '13004001',
    '13004002',
    '13004003',
    '13004004',
    '13004005',
    '13004006',
    '13005000',
    '13005001',
    '13005002',
    '13005003',
    '13005004',
    '13005005',
    '13005006',
    '13005007',
    '13005008',
    '13005009',
    '13005010',
    '13005011',
    '13005012',
    '13005013',
    '13005014',
    '13005015',
    '13005016',
    '13005017',
    '13005018',
    '13005019',
    '13005020',
    '13005021',
    '13005022',
    '13005023',
    '13005024',
    '13005025',
    '13005026',
    '13005027',
    '13005028',
    '13005029',
    '13005030',
    '13005031',
    '13005032',
    '13005033',
    '13005034',
    '13005035',
    '13005036',
    '13005037',
    '13005038',
    '13005039',
    '13005040',
    '13005041',
    '13005042',
    '13005043',
    '13005044',
    '13005045',
    '13005046',
    '13005047',
    '13005048',
    '13005049',
    '13005050',
    '13005051',
    '13005052',
    '13005053',
    '13005054',
    '13005055',
    '13005056',
    '13005057',
    '13005058',
    '13005059',
    '18021000',
    '18021001',
    '18021002',
    '18037005',
    '19025000',
    '19025001',
    '19025002',
    '19025003',
    '19025004',
]


def update_transactions_is_food(data, context):
    print(f'''
    update_transactions_data data={data}
    update_transactions_data context={context}
    ''')

    # Get Transaction document from Firestore
    path_parts = context.resource.split('/documents/')[1].split('/')
    collection_path = path_parts[0]
    document_path = '/'.join(path_parts[1:])
    users_collection = firestore_client.collection(collection_path)
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
