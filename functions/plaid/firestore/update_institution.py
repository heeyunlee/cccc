from typing import Dict, Optional

from endpoints.institution_endpoints import institutions_get_by_id

from firestore.cloud_firestore import CloudFirestore, FirestoreEnv


def update_institution(data: dict, context):
    print(f'''
        data: {type(data)}, {data},
        context: {type(context)}, {context},
    ''')

    path_parts = context.resource.split('/documents/')[1].split('/')
    collection_path = path_parts[0]
    document_path = '/'.join(path_parts[1:])

    # TODO: Change Environment for production for release
    firestore = CloudFirestore(FirestoreEnv.PRODUCTION)
    client = firestore.client()

    users_collection = client.collection(collection_path)
    account_ref = users_collection.document(document_path)
    account_dict = account_ref.get().to_dict()
    institution_id = account_dict.get('institution_id')

    institutions_get_result = institutions_get_by_id(institution_id)
    institution: Optional[Dict] = institutions_get_result.get('institution')

    # if [institution] is None, it means that an error occurred. So return error
    if institution is None:
        return institutions_get_result

    institution_collections = client.collection('institutions')
    institution_doc = institution_collections.document(institution_id)
    institution_snapshot = institution_doc.get()

    if institution_snapshot.exists:
        return 'instituion document exist. Do nothing and return'

    institution_doc.create(institution)

    return 'Created new institution document'
