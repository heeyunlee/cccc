import 'package:cccc/models/merchant.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/models/user.dart';
import 'package:cccc/services/firestore_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, Query;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firestore_service.dart';

final databaseProvider = Provider.family<FirestoreDatabase, String>(
  (ref, uid) {
    return FirestoreDatabase(uid: uid);
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
        fromBuilder: (json) => User.fromMap(json!),
        toBuilder: (model) => model.toMap(),
      );

  Future<void> setUser(User user) => _service.setData<User>(
        path: FirestorePath.user(user.uid),
        data: user,
        fromBuilder: (json) => User.fromMap(json!),
        toBuilder: (model) => model.toMap(),
      );

  Future<void> updateUser(User oldData, Map<String, dynamic> newData) =>
      _service.updateData<User>(
        path: FirestorePath.user(oldData.uid),
        data: newData,
        fromBuilder: (json) => User.fromMap(json!),
        toBuilder: (model) => model.toMap(),
      );

  Future<void> deleteUser() => _service.deleteData(
        path: FirestorePath.user(uid!),
      );

  Stream<User?> userStream() => _service.documentStream(
        path: FirestorePath.user(uid!),
        fromBuilder: (json) => User.fromMap(json!),
        toBuilder: (model) => model.toMap(),
      );

  Future<void> updateTransaction(
    Transaction oldData,
    Map<String, dynamic> newData,
  ) {
    return _service.updateData<Transaction>(
      path: FirestorePath.transaction(uid!, oldData.transactionId),
      data: newData,
      fromBuilder: (json) => Transaction.fromMap(json!),
      toBuilder: (model) => model.toMap(),
    );
  }

  Stream<List<Transaction?>> transactionsStream([int? limit]) {
    return _service.collectionStream<Transaction>(
      path: FirestorePath.transactions(uid!),
      fromBuilder: (json) => Transaction.fromMap(json!),
      toBuilder: (model) => model.toMap(),
      orderByField: 'date',
      descending: true,
      limit: limit,
    );
  }

  Query<Transaction> transactionsQuery({
    int limit = 15,
    DocumentSnapshot<Transaction>? startAfterDocument,
  }) {
    if (startAfterDocument == null) {
      return _service.query(
        path: FirestorePath.transactions(uid!),
        fromBuilder: (json) => Transaction.fromMap(json!),
        toBuilder: (model) => model.toMap(),
        orderByField: 'date',
        limit: limit,
      );
    } else {
      return _service.queryStartAfter(
        path: FirestorePath.transactions(uid!),
        fromBuilder: (json) => Transaction.fromMap(json!),
        toBuilder: (model) => model.toMap(),
        orderByField: 'date',
        limit: limit,
        startAfterDocument: startAfterDocument,
      );
    }
  }

  Stream<List<Transaction?>> transactionsStreamForSpecificAccount(
    String accountId, [
    int? limit,
  ]) {
    return _service.whereCollectionStream<Transaction>(
      path: FirestorePath.transactions(uid!),
      fromBuilder: (json) => Transaction.fromMap(json!),
      toBuilder: (model) => model.toMap(),
      orderByField: 'date',
      descending: true,
      where: 'account_id',
      isEqualTo: accountId,
      limit: limit,
    );
  }

  Stream<List<Transaction?>> transactionsStreamSpecificAmount(num amount) {
    return _service.whereCollectionStream<Transaction>(
      path: FirestorePath.transactions(uid!),
      fromBuilder: (json) => Transaction.fromMap(json!),
      toBuilder: (model) => model.toMap(),
      orderByField: 'date',
      descending: true,
      where: 'amount',
      isEqualTo: amount,
    );
  }

  Stream<List<Account?>> accountsStream() {
    return _service.collectionStream<Account>(
      path: FirestorePath.accounts(uid!),
      fromBuilder: (json) => Account.fromMap(json!),
      toBuilder: (model) => model.toMap(),
      orderByField: 'type',
      descending: false,
    );
  }

  Future<Account?> accountGet(String accountId) {
    return _service.getDocument<Account>(
      path: FirestorePath.account(uid!, accountId),
      fromBuilder: (json) => Account.fromMap(json!),
      toBuilder: (model) => model.toMap(),
    );
  }

  Stream<Account?> accountStream(String accountId) {
    return _service.documentStream<Account>(
      path: FirestorePath.account(uid!, accountId),
      fromBuilder: (json) => Account.fromMap(json!),
      toBuilder: (model) => model.toMap(),
    );
  }

  Stream<Institution?> institutionStream(String institutionId) {
    return _service.documentStream<Institution?>(
      path: FirestorePath.institution(institutionId),
      fromBuilder: (json) => json != null ? Institution.fromMap(json) : null,
      toBuilder: (model) => model!.toMap(),
    );
  }

  // Stream<List<Merchant?>> merchantsStream() {
  //   return _service.collectionStream<Merchant>(
  //     path: FirestorePath.merchants(),
  //     fromBuilder: (json) => Merchant.fromMap(json!),
  //     toBuilder: (model) => model.toMap(),
  //     orderByField: 'name',
  //     descending: false,
  //   );
  // }

  Query<Merchant> merchantQuery({
    int limit = 15,
    DocumentSnapshot<Merchant>? startAfterDocument,
  }) {
    if (startAfterDocument == null) {
      return _service.query<Merchant>(
        path: FirestorePath.merchants(),
        fromBuilder: (json) => Merchant.fromMap(json!),
        toBuilder: (model) => model.toMap(),
        orderByField: 'name',
        descending: false,
        limit: limit,
      );
    } else {
      return _service.queryStartAfter(
        path: FirestorePath.merchants(),
        fromBuilder: (json) => Merchant.fromMap(json!),
        toBuilder: (model) => model.toMap(),
        orderByField: 'name',
        descending: false,
        limit: limit,
        startAfterDocument: startAfterDocument,
      );
    }
  }
}
