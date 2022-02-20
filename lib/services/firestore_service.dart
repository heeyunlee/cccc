import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Making private constructor
  FirestoreService._();
  static final instance = FirestoreService._();

  final _instance = FirebaseFirestore.instance;

  // Document Future
  Future<T?> getDocument<T>({
    required String path,
    required T Function(Map<String, dynamic>? data) fromBuilder,
    required Map<String, Object?> Function(T model) toBuilder,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path).withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data()),
          toFirestore: (model, _) => toBuilder(model),
        );
    final snapshot = await reference.get();

    if (snapshot.exists) {
      return snapshot.data()!;
    }
    return null;
  }

  // Create new Data
  Future<void> setData<T>({
    required String path,
    required T data,
    required T Function(Map<String, dynamic>? data) fromBuilder,
    required Map<String, Object?> Function(T model) toBuilder,
  }) async {
    final reference = _instance.doc(path).withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data()),
          toFirestore: (model, _) => toBuilder(model),
        );

    await reference.set(data);
  }

  // Update existing Data
  Future<void> updateData<T>({
    required String path,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>? data) fromBuilder,
    required Map<String, Object?> Function(T model) toBuilder,
  }) async {
    final reference = _instance.doc(path).withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data()),
          toFirestore: (model, _) => toBuilder(model),
        );

    await reference.update(data);
  }

  // Delete data
  Future<void> deleteData({
    required String path,
  }) async {
    final reference = _instance.doc(path);
    await reference.delete();
  }

  // Single Document Stream
  Stream<T?> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data) fromBuilder,
    required Map<String, Object?> Function(T model) toBuilder,
  }) {
    final reference = _instance.doc(path).withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data()),
          toFirestore: (model, _) => toBuilder(model),
        );

    final snapshot = reference.snapshots();

    return snapshot.map((event) => event.data());
  }

  /// Collection Stream
  Stream<List<T?>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data) fromBuilder,
    required Map<String, Object?> Function(T model) toBuilder,
    required String orderByField,
    required bool descending,
    int? limit,
  }) {
    Query<T> reference = _instance
        .collection(path)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data()),
          toFirestore: (model, _) => toBuilder(model),
        )
        .orderBy(orderByField, descending: descending);

    if (limit != null) reference = reference.limit(limit);

    final snapshots = reference.snapshots();

    return snapshots.map((e) => e.docs.map((doc) => doc.data()).toList());
  }

  /// Collection Stream
  Stream<List<T?>> whereCollectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data) fromBuilder,
    required Map<String, Object?> Function(T model) toBuilder,
    required String orderByField,
    required bool descending,
    required Object where,
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
    int? limit,
  }) {
    Query<T> reference = _instance
        .collection(path)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data()),
          toFirestore: (model, _) => toBuilder(model),
        )
        .where(
          where,
          isEqualTo: isEqualTo,
          isNotEqualTo: isNotEqualTo,
          isLessThan: isLessThan,
          isLessThanOrEqualTo: isLessThanOrEqualTo,
          isGreaterThan: isGreaterThan,
          isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
          arrayContains: arrayContains,
          arrayContainsAny: arrayContainsAny,
          whereIn: whereIn,
          whereNotIn: whereNotIn,
          isNull: isNull,
        )
        .orderBy(orderByField, descending: descending);

    if (limit != null) reference = reference.limit(limit);

    final snapshots = reference.snapshots();

    return snapshots.map((e) => e.docs.map((doc) => doc.data()).toList());
  }

  // Query
  Query<T> query<T>({
    required String path,
    required T Function(Map<String, dynamic>? data) fromBuilder,
    required Map<String, Object?> Function(T model) toBuilder,
    required String orderByField,
    bool descending = true,
    required int limit,
  }) {
    return _instance
        .collection(path)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data()),
          toFirestore: (model, _) => toBuilder(model),
        )
        .orderBy(orderByField, descending: descending)
        .limit(limit);
  }

  // Query Snapshot
  Query<T> queryStartAfter<T>({
    required String path,
    required T Function(Map<String, dynamic>? data) fromBuilder,
    required Map<String, Object?> Function(T model) toBuilder,
    required String orderByField,
    bool descending = true,
    required int limit,
    required DocumentSnapshot<T> startAfterDocument,
  }) {
    return _instance
        .collection(path)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data()),
          toFirestore: (model, _) => toBuilder(model),
        )
        .orderBy(orderByField, descending: descending)
        .limit(limit)
        .startAfterDocument(startAfterDocument);
  }

  // Query Snapshot
  Future<QuerySnapshot<T>> querySnapshot<T>({
    required String path,
    required T Function(Map<String, dynamic>? data) fromBuilder,
    required Map<String, Object?> Function(T model) toBuilder,
    required String orderByField,
    bool descending = true,
    required int limit,
  }) {
    final query = _instance
        .collection(path)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data()),
          toFirestore: (model, _) => toBuilder(model),
        )
        .orderBy(orderByField, descending: descending)
        .limit(limit);

    return query.get();
  }

  // Collection Stream
  Future<QuerySnapshot<T>> queryWithPagination<T>({
    required String path,
    required T Function(Map<String, dynamic>? data) fromBuilder,
    required Map<String, Object?> Function(T model) toBuilder,
    required String orderByField,
    bool descending = true,
    required DocumentSnapshot<T> startAfterDocument,
    required int limit,
  }) {
    final query = _instance
        .collection(path)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data()),
          toFirestore: (model, _) => toBuilder(model),
        )
        .orderBy(orderByField, descending: descending)
        .startAfterDocument(startAfterDocument)
        .limit(limit);

    return query.get();
  }
}
