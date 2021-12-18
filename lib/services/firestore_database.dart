import 'package:cccc/model/user.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firestore_service.dart';

final databaseProvider = Provider<FirestoreDatabase?>(
  (ref) {
    final auth = ref.watch(authProvider);

    if (auth.currentUser?.uid != null) {
      return FirestoreDatabase(uid: auth.currentUser!.uid);
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

  Future<void> setUser(User user) => _service.setData<User>(
        path: FirestorePath.user(user.uid),
        data: user,
        fromBuilder: (json, id) => User.fromJson(json!),
        toBuilder: (model) => model.toJson(),
      );

  Future<void> updateUser(User oldData, User newData) =>
      _service.updateData<User>(
        path: FirestorePath.user(oldData.uid),
        data: newData.toJson(),
        fromBuilder: (json, id) => User.fromJson(json!),
        toBuilder: (model) => model.toJson(),
      );
}
