from google.cloud import firestore
from source.enums import FirestoreEnv


class CloudFirestore():
    def __init__(self, env: FirestoreEnv):
        self.env = env

    def client(self):
        if self.env is self.env.TESTING:
            return firestore.Client.from_service_account_json('google-services.json')
        else:
            return firestore.Client()
