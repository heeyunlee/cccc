import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, Query;

import 'package:cccc/models/merchant.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/models/user.dart';

import 'firestore_service.dart';

/// Creates a document path for Cloud Firestore
class _FirestorePath {
  static String user(String uid) => 'users/$uid';

  static String transactions(String uid) => 'users/$uid/transactions';
  static String transaction(String uid, String transactionId) =>
      'users/$uid/transactions/$transactionId';

  static String accounts(String uid) => 'users/$uid/accounts';
  static String account(String uid, String accountId) =>
      'users/$uid/accounts/$accountId';

  static String institution(String id) => 'institutions/$id';

  static String merchants() => 'merchants';
}

/// Creates a class that interacts with [FirestoreService] to create, update,
/// delete documents and get the [Stream] or [Query] of documents
class Database {
  Database({this.uid});

  /// Current user's uid
  final String? uid;

  /// Instance that interacts with [FirestoreService]
  final FirestoreService _service = FirestoreService.instance;

  /// Get [User] document in Firestore
  Future<User?> getUser(String uid) => _service.getDocument<User>(
        path: _FirestorePath.user(uid),
        fromBuilder: (json) => User.fromMap(json!),
        toBuilder: (model) => model.toMap(),
      );

  /// Create [User] document in Firestore
  Future<void> setUser(User user) => _service.setData<User>(
        path: _FirestorePath.user(user.uid),
        data: user,
        fromBuilder: (json) => User.fromMap(json!),
        toBuilder: (model) => model.toMap(),
      );

  /// Update [User] document in Firestore
  Future<void> updateUser(User oldData, Map<String, dynamic> newData) {
    return _service.updateData<User>(
      path: _FirestorePath.user(oldData.uid),
      data: newData,
      fromBuilder: (json) => User.fromMap(json!),
      toBuilder: (model) => model.toMap(),
    );
  }

  Future<void> deleteUser() {
    return _service.deleteData(path: _FirestorePath.user(uid!));
  }

  Stream<User?> userStream() => _service.documentStream(
        path: _FirestorePath.user(uid!),
        fromBuilder: (json) => User.fromMap(json!),
        toBuilder: (model) => model.toMap(),
      );

  Future<void> updateTransaction(
    Transaction oldData,
    Map<String, dynamic> newData,
  ) {
    return _service.updateData<Transaction>(
      path: _FirestorePath.transaction(uid!, oldData.transactionId),
      data: newData,
      fromBuilder: (json) => Transaction.fromMap(json!),
      toBuilder: (model) => model.toMap(),
    );
  }

  Stream<Transaction?> transactionStream(String transactionId) {
    return _service.documentStream<Transaction>(
      path: _FirestorePath.transaction(uid!, transactionId),
      fromBuilder: (json) => Transaction.fromMap(json!),
      toBuilder: (model) => model.toMap(),
    );
  }

  Stream<List<Transaction?>> transactionsStream([int? limit]) {
    return _service.collectionStream<Transaction>(
      path: _FirestorePath.transactions(uid!),
      fromBuilder: (json) => Transaction.fromMap(json!),
      toBuilder: (model) => model.toMap(),
      orderByField: 'date',
      descending: true,
      limit: limit,
    );
  }

  Stream<List<Transaction?>> transactionsStreamForSpecificAccount(
    String accountId, [
    int? limit,
  ]) {
    return _service.whereCollectionStream<Transaction>(
      path: _FirestorePath.transactions(uid!),
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
      path: _FirestorePath.transactions(uid!),
      fromBuilder: (json) => Transaction.fromMap(json!),
      toBuilder: (model) => model.toMap(),
      orderByField: 'date',
      descending: true,
      where: 'amount',
      isEqualTo: amount,
    );
  }

  Query<Transaction> transactionsQuery({
    int limit = 15,
    DocumentSnapshot<Transaction>? startAfterDocument,
  }) {
    if (startAfterDocument == null) {
      return _service.query(
        path: _FirestorePath.transactions(uid!),
        fromBuilder: (json) => Transaction.fromMap(json!),
        toBuilder: (model) => model.toMap(),
        orderByField: 'date',
        limit: limit,
      );
    } else {
      return _service.queryStartAfter(
        path: _FirestorePath.transactions(uid!),
        fromBuilder: (json) => Transaction.fromMap(json!),
        toBuilder: (model) => model.toMap(),
        orderByField: 'date',
        limit: limit,
        startAfterDocument: startAfterDocument,
      );
    }
  }

  Stream<List<Account?>> accountsStream() {
    return _service.collectionStream<Account>(
      path: _FirestorePath.accounts(uid!),
      fromBuilder: (json) => Account.fromMap(json!),
      toBuilder: (model) => model.toMap(),
      orderByField: 'type',
      descending: false,
    );
  }

  Future<Account?> accountGet(String accountId) {
    return _service.getDocument<Account>(
      path: _FirestorePath.account(uid!, accountId),
      fromBuilder: (json) => Account.fromMap(json!),
      toBuilder: (model) => model.toMap(),
    );
  }

  Stream<Account?> accountStream(String accountId) {
    return _service.documentStream<Account>(
      path: _FirestorePath.account(uid!, accountId),
      fromBuilder: (json) => Account.fromMap(json!),
      toBuilder: (model) => model.toMap(),
    );
  }

  Stream<Institution?> institutionStream(String institutionId) {
    return _service.documentStream<Institution?>(
      path: _FirestorePath.institution(institutionId),
      fromBuilder: (json) => json != null ? Institution.fromMap(json) : null,
      toBuilder: (model) => model!.toMap(),
    );
  }

  Query<Merchant> merchantQuery({
    int limit = 15,
    DocumentSnapshot<Merchant>? startAfterDocument,
  }) {
    if (startAfterDocument == null) {
      return _service.query<Merchant>(
        path: _FirestorePath.merchants(),
        fromBuilder: (json) => Merchant.fromMap(json!),
        toBuilder: (model) => model.toMap(),
        orderByField: 'name',
        descending: false,
        limit: limit,
      );
    } else {
      return _service.queryStartAfter(
        path: _FirestorePath.merchants(),
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
