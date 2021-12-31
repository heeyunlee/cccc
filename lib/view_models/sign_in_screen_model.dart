import 'package:cccc/constants/logger_init.dart';
import 'package:cccc/model/user.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/view/show_adaptive_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signInViewModelProvider = ChangeNotifierProvider<SignInViewModel>(
  (ref) => SignInViewModel(
    auth: ref.watch(authProvider),
  ),
);

class SignInViewModel with ChangeNotifier {
  SignInViewModel({
    required this.auth,
  });

  final FirebaseAuthService auth;

  bool isLoading = false;
  dynamic error;

  Future<void> _signIn(
    BuildContext context, {
    required Future<void> Function() signInMethod,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      await signInMethod();
      error = null;
    } on fire_auth.FirebaseException catch (e) {
      error = e;
      _showSignInError(context, exception: error);

      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInAnonymously(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await _signIn(
      context,
      signInMethod: () async {
        await auth.signInAnonymously();

        final uid = auth.currentUser!.uid;

        final user = User(
          uid: uid,
          plaidAccessToken: null,
          plaidItemId: null,
          plaidRequestId: null,
        );

        final database = ref.watch(databaseProvider(uid));

        await database!.setUser(user);
      },
    );
  }

  Future<void> signInWithGoogle(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await _signIn(
      context,
      signInMethod: () async {
        await auth.signInWithGoogle();

        final uid = auth.currentUser!.uid;
        final now = DateTime.now();

        final newUserData = User(
          uid: uid,
          plaidAccessToken: null,
          plaidItemId: null,
          plaidRequestId: null,
          lastLoginDate: now,
        );

        final database = ref.watch(databaseProvider(uid));

        final oldUserData = await database!.getUser(uid);

        if (oldUserData != null) {
          await database.updateUser(
            oldUserData,
            newUserData.toMap(),
          );
        } else {
          await database.setUser(newUserData);
        }
      },
    );
  }

  void _showSignInError(
    BuildContext context, {
    required fire_auth.FirebaseException exception,
  }) {
    logger.e(exception);

    showAdaptiveAlertDialog(
      context,
      defaultActionText: 'OK',
      title: 'Sign in failed',
      content: 'Sign In Failed! Please try again later.',
    );
  }
}
