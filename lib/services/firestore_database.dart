import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/models/user.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firestore_service.dart';

final databaseProvider = Provider.family<FirestoreDatabase?, String?>(
  (ref, id) {
    final auth = ref.watch(authProvider);
    final uid = auth.currentUser?.uid;

    if (id != null) {
      return FirestoreDatabase(uid: id);
    } else if (uid != null) {
      return FirestoreDatabase(uid: uid);
    } else {
      return null;
    }
  },
);

class FirestoreDatabase {
  FirestoreDatabase({
    this.uid,
  });

  final String? uid;

  final _service = FirestoreService.instance;

  Future<User?> getUser(String uid) => _service.getDocument<User>(
        path: FirestorePath.user(uid),
        fromBuilder: (json, id) => User.fromMap(json!),
        toBuilder: (model) => model.toMap(),
      );

  Future<void> setUser(User user) => _service.setData<User>(
        path: FirestorePath.user(user.uid),
        data: user,
        fromBuilder: (json, id) => User.fromMap(json!),
        toBuilder: (model) => model.toMap(),
      );

  Future<void> updateUser(User oldData, Map<String, dynamic> newData) =>
      _service.updateData<User>(
        path: FirestorePath.user(oldData.uid),
        data: newData,
        fromBuilder: (json, id) => User.fromMap(json!),
        toBuilder: (model) => model.toMap(),
      );

  Future<void> deleteUser() => _service.deleteData(
        path: FirestorePath.user(uid!),
      );

  Stream<User?> userStream() => _service.documentStream(
        path: FirestorePath.user(uid!),
        fromBuilder: (json, id) => User.fromMap(json!),
        toBuilder: (model) => model.toMap(),
      );

  Stream<List<Transaction?>> transactionsStream() =>
      _service.collectionStream<Transaction>(
        path: FirestorePath.transactions(uid!),
        fromBuilder: (json, id) => Transaction.fromMap(json!),
        toBuilder: (model) => model.toMap(),
        orderByField: 'date',
        descending: true,
      );

  Stream<List<Account?>> accountsStream() => _service.collectionStream<Account>(
        path: FirestorePath.accounts(uid!),
        fromBuilder: (json, id) => Account.fromMap(json!),
        toBuilder: (model) => model.toMap(),
        orderByField: 'type',
        descending: false,
      );
}
