import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/view/auth_state_error.dart';
import 'package:cccc/view/home.dart';
import 'package:cccc/view/sign_in.dart';
import 'package:cccc/view/splash.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthStatesChangesStreamBuilder extends ConsumerWidget {
  const AuthStatesChangesStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return CustomStreamBuilder<fire_auth.User?>(
      stream: auth.authStateChanges(),
      loadingWidget: const Splash(),
      errorBuilder: (context, error) => AuthStateError(error: error),
      builder: (context, user) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: user != null ? const Home() : const SignIn(),
        );
      },
    );
  }
}
