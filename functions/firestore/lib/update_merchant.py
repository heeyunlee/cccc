import uuid

from google.cloud.functions_v1.context import Context

from cloud_firestore import CloudFirestore, FirestoreEnv


def update_merchant(data: dict, context: Context):
    try:
        # TODO: Change Environment for production for release
        firestore = CloudFirestore(FirestoreEnv.PRODUCTION)
        client = firestore.client()

        merchant_name = data['oldValue']['fields']['merchant_name']['stringValue']
        print(f'Merchant name: {merchant_name}')

        if merchant_name:
            merchants_ref = client.collection('merchants')
            merchants_where_ref = merchants_ref.where(
                'name', '==', merchant_name)
            snapshots = merchants_where_ref.get()
            merchant_dict_list = [x.to_dict() for x in snapshots]
            print(f'matching merchants got: {merchant_dict_list}')

            if not merchant_dict_list:
                print('list is empty, so creating a new merchant document')

                id = uuid.uuid4()

                merchant_ref = merchants_ref.document(str(id))
                merchant_ref.create({
                    'name': merchant_name,
                    'merchantId': str(id),
                    'products': [],
                })
                print(f'created new item. {merchant_ref}')

    except Exception as e:
        print(f'error found: {str(e)}')
