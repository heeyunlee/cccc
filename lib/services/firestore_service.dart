import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Making private constructor
  FirestoreService._();
  static final instance = FirestoreService._();

  final _instance = FirebaseFirestore.instance;

  // Create new Data
  Future<void> setData<T>({
    required String path,
    required T data,
    required T Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Map<String, Object?> Function(T model) toBuilder,
  }) async {
    final reference = _instance.doc(path).withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        );

    await reference.set(data);
  }

  // Update existing Data
  Future<void> updateData<T>({
    required String path,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Map<String, Object?> Function(T model) toBuilder,
  }) async {
    final reference = _instance.doc(path).withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
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
    required T Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Map<String, Object?> Function(T model) toBuilder,
  }) {
    final reference = _instance.doc(path).withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        );

    final snapshots = reference.snapshots();

    return snapshots.map((event) => event.data());
  }

  // Collection Stream
  Stream<List<T?>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Map<String, Object?> Function(T model) toBuilder,
    required String orderByField,
    required bool descending,
  }) {
    final reference = _instance
        .collection(path)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        )
        .orderBy(orderByField, descending: descending);

    final snapshots = reference.snapshots();
    final list = snapshots.map(
      (event) => event.docs.map((doc) => doc.data()).toList(),
    );

    return list;
  }
}
