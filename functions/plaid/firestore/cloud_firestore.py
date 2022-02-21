from enum import Enum

from google.cloud import firestore


class FirestoreEnv(Enum):
    TESTING = 0
    PRODUCTION = 1


class CloudFirestore():
    def __init__(self, env: FirestoreEnv):
        self.env = env

    def client(self):
        if self.env is self.env.TESTING:
            return firestore.Client.from_service_account_json('firestore/google-services.json')
        else:
            return firestore.Client()
