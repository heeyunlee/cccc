import 'package:cccc/services/logger_init.dart';
import 'package:cccc/models/user.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
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
      _showSignInError(context, exception: e);
    } catch (e) {
      logger.e(e);

      showAdaptiveAlertDialog(
        context,
        title: 'Sign in failed',
        content: 'Sign in failed. Please try again later.',
        defaultActionText: 'OK',
      );

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

        await database.setUser(user);
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
        final user = await auth.signInWithGoogle();

        final uid = user!.uid;
        final now = DateTime.now();

        final newUserData = {
          'uid': uid,
          'lastLoginDate': now,
        };

        final database = ref.watch(databaseProvider(uid));
        final oldUserData = await database.getUser(uid);

        if (oldUserData != null) {
          await database.updateUser(
            oldUserData,
            newUserData,
          );
        } else {
          await database.setUser(User.fromMap(newUserData));
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
