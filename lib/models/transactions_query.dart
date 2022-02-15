import 'package:cloud_firestore/cloud_firestore.dart';

class ListQueryResponse<T> {
  const ListQueryResponse({required this.list, required this.lastDocSnapshot});

  final List<T> list;
  final DocumentSnapshot<T>? lastDocSnapshot;
}
