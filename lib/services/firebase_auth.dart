import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authProvider = Provider<FirebaseAuthService>(
  (ref) => FirebaseAuthService(),
);

class FirebaseAuthService {
  final fire_auth.FirebaseAuth _auth = fire_auth.FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

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

  Future<fire_auth.User?> signInWithGoogle() async {
    final googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // Obtain the auth details from the request
      final googleAuth = await googleSignInAccount.authentication;

      if (googleAuth.idToken != null) {
        final authCredential = fire_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await _auth.signInWithCredential(authCredential);
        final user = userCredential.user;
        final currentUser = _auth.currentUser;
        assert(user!.uid == currentUser!.uid);

        _setUser(user!);

        return user;
      } else {
        throw fire_auth.FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw fire_auth.FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  Future<void> signOut() async {
    final signedInWithGoogle = await googleSignIn.isSignedIn();

    if (signedInWithGoogle) {
      await googleSignIn.signOut();
    }

    _setUser(null);
    assert(user == null);

    await _auth.signOut();
  }
}
