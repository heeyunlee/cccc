import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/local_authentication_service.dart';
import 'package:cccc/views/auth_state_error.dart';
import 'package:cccc/views/local_authenticate_screen.dart';
import 'package:cccc/views/sign_in.dart';
import 'package:cccc/views/splash.dart';
import 'package:cccc/views/home.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthStatesWidgetBuilder extends ConsumerStatefulWidget {
  const AuthStatesWidgetBuilder({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthStatesWidgetBuilderState();
}

class _AuthStatesWidgetBuilderState
    extends ConsumerState<AuthStatesWidgetBuilder> {
  @override
  void initState() {
    super.initState();
    ref.read(localAuthenticationServiceProvider).getLocalAuthPrefs();
  }

  @override
  Widget build(BuildContext context) {
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
    final localAuth = ref.watch(localAuthenticationServiceProvider);

    if (localAuth.useLocalAuth && !localAuth.isAuthenticated) {
      return const LocalAuthenticationScreen();
    } else {
      return const Home();
    }
  }
}
