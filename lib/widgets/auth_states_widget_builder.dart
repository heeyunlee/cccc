import 'package:cccc/providers.dart'
    show
        authProvider,
        sharedPreferenceServiceProvider,
        localAuthenticationServiceProvider;

import 'package:cccc/views/auth_state_error.dart';
import 'package:cccc/views/local_authenticate_screen.dart';
import 'package:cccc/views/sign_in.dart';
import 'package:cccc/views/splash.dart';
import 'package:cccc/views/home.dart';
import 'package:cccc/widgets/custom_future_builder.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthStatesWidgetBuilder extends ConsumerWidget {
  const AuthStatesWidgetBuilder({Key? key}) : super(key: key);

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
          child: user != null ? _homeOrLocalAuth(ref) : const SignIn(),
        );
      },
    );
  }

  Widget _homeOrLocalAuth(WidgetRef ref) {
    final sharedPref = ref.watch(sharedPreferenceServiceProvider);

    return CustomFutureBuilder<bool?>(
      future: sharedPref.get('useLocalAuth', bool),
      builder: (context, useLocalAuth) {
        ref
            .read(localAuthenticationServiceProvider)
            .setUseLocalAuth(useLocalAuth);

        if (useLocalAuth ?? false) {
          final localAuth = ref.watch(localAuthenticationServiceProvider);

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
      loadingWidget: const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
