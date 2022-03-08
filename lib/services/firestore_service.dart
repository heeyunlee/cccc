import 'package:cloud_firestore/cloud_firestore.dart';

/// A class that interacts with [FirebaseFirestore] to get, set, update, or delete
/// data, as well as get [Stream] or [Query] of data from Firebase Cloud
/// Firestore.
///
class FirestoreService {
  // Making private constructor
  FirestoreService._();
  static final instance = FirestoreService._();

  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  /// Get the document with the type [T] from document [path] using
  /// [FirebaseFirestore].
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

  /// Create a new document with the type [T] at the [path] using [FirebaseFirestore]
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

  /// Update the document in the document [path] with the [data]
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

  /// Delete the document in the [path]
  Future<void> deleteData({
    required String path,
  }) async {
    final reference = _instance.doc(path);
    await reference.delete();
  }

  /// Get the [Stream] of document [T] from the [path]
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

  /// Get the [Stream] of list of document with the type [T] from the [path].
  ///
  /// User also has to specify [orderByField] and whether it should be ordered
  /// [descending] or ascending.
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

  /// Get the [Stream] of list of document with the type [T] from the [path].
  ///
  /// User also has to specify [orderByField] and whether it should be ordered
  /// [descending] or ascending and filter the collection by specifying [where]
  /// field.
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

  /// Get the [Query] of the document typed [T] in the [path]
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

  /// Get the [Query] of the document typed [T] in the [path] starting after
  /// [startAfterDocument].
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
}
