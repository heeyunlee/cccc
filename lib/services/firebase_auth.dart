import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = Provider<FirebaseAuthService>(
  (ref) => FirebaseAuthService(),
);

class FirebaseAuthService {
  final fire_auth.FirebaseAuth _auth = fire_auth.FirebaseAuth.instance;

  Stream<fire_auth.User?> authStateChanges() => _auth.authStateChanges();

  fire_auth.User? get currentUser => _auth.currentUser;

  fire_auth.User? user;

  void _setUser(fire_auth.User? value) {
    user = value;
  }

  Future<fire_auth.User?> signInAnonymously() async {
    final userCredential = await _auth.signInAnonymously();
    final user = userCredential.user;
    final currentUser = _auth.currentUser;

    assert(user!.uid == currentUser!.uid);

    _setUser(user!);

    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();

    _setUser(null);
  }
}
