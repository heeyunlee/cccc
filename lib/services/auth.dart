import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

final authStateChangesProvider = StreamProvider<User?>(
  (ref) => ref.watch(authProvider).authStateChanges(),
);
