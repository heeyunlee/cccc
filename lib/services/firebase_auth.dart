import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cccc/services/logger_init.dart';
import 'package:cccc/services/shared_preference_service.dart';

class FirebaseAuthService {
  final fire_auth.FirebaseAuth _auth = fire_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _sharedPreferencesService = SharedPreferencesService();

  Stream<fire_auth.User?> authStateChanges() => _auth.authStateChanges();

  fire_auth.User? get currentUser => _auth.currentUser;

  fire_auth.User? _user;

  void _setUser(fire_auth.User? value) {
    _user = value;
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
    final googleSignInAccount = await _googleSignIn.signIn();

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
    final signedInWithGoogle = await _googleSignIn.isSignedIn();

    if (signedInWithGoogle) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();

    _setUser(null);
    assert(_user == null);

    final removeLocalAuth = await _sharedPreferencesService.remove(
      'useLocalAuth',
    );

    logger.d('''
      user: $_user,
      removeLocalAuthConfig?: $removeLocalAuth
    ''');
  }
}
