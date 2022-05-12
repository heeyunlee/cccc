import 'package:cccc/providers.dart'
    show firebaseAuthProvider, localAuthenticationServiceProvider;

import 'package:cccc/views/error/auth_state_error.dart';
import 'package:cccc/views/settings/local_authenticate_screen.dart';
import 'package:cccc/views/sign_in/sign_in.dart';
import 'package:cccc/views/sign_in/splash.dart';
import 'package:cccc/views/home/home.dart';
import 'package:cccc/widgets/custom_future_builder.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthStatesWidgetBuilder extends ConsumerWidget {
  const AuthStatesWidgetBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);

    return CustomStreamBuilder<fire_auth.User?>(
      stream: auth.authStateChanges,
      loadingWidget: const Splash(),
      errorBuilder: (context, error) => AuthStateError(error: error),
      builder: (context, user) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: user != null ? _homeOrLocalAuth(ref) : const SignIn(),
        );
      },
    );
  }

  Widget _homeOrLocalAuth(WidgetRef ref) {
    final localAuth = ref.watch(localAuthenticationServiceProvider);

    return CustomFutureBuilder<bool>(
      future: localAuth.getUseLocalAuth(),
      builder: (context, useLocalAuth) {
        if (useLocalAuth!) {
          if (localAuth.isAuthenticated) {
            return const Home();
          } else {
            return const LocalAuthenticationScreen();
          }
        } else {
          return const Home();
        }
      },
      errorBuilder: (context, e) => Text(e.toString()),
      loadingWidget: const Splash(),
    );
  }
}
