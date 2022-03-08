import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cccc/services/logger_init.dart';
import 'package:cccc/services/shared_preference_service.dart';

/// A class that interacts with [FirebaseAuth] to handle signing in and out
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final SharedPreferencesService _prefs = SharedPreferencesService();

  /// get `Stream<User?>` from [FirebaseAuth]'s `authStateChanges()` instance
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get current [User] from [FirebaseAuth]
  User? get currentUser => _auth.currentUser;

  User? _user;

  /// Calls `_auth.signInAnonymously()` method to sign in the user and change
  /// [_user] value to the corresponding user
  Future<User?> signInAnonymously() async {
    final userCredential = await _auth.signInAnonymously();
    final user = userCredential.user;
    final currentUser = _auth.currentUser;

    assert(user!.uid == currentUser!.uid);

    _user = user;

    return _user;
  }

  /// Calls [GoogleSignIn]'s sign in method to sign in the user and change the
  /// [_user] value to the corresponding user
  Future<User?> signInWithGoogle() async {
    final googleSignInAccount = await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // Obtain the auth details from the request
      final googleAuth = await googleSignInAccount.authentication;

      if (googleAuth.idToken != null) {
        final authCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await _auth.signInWithCredential(authCredential);
        final user = userCredential.user;
        final currentUser = _auth.currentUser;
        assert(user!.uid == currentUser!.uid);

        _user = user;

        return _user;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  /// Calls sign out method for each corresponding sign in method, i.e., if the
  /// user signed in with Google, the function calls `signOut` method from [GoogleSignIn]
  /// class
  Future<void> signOut() async {
    final signedInWithGoogle = await _googleSignIn.isSignedIn();

    if (signedInWithGoogle) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();

    _user = null;

    final removeLocalAuth = await _prefs.remove('useLocalAuth');

    logger.d('''
      user: $_user,
      removeLocalAuthConfig?: $removeLocalAuth
    ''');
  }
}
