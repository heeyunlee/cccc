import 'package:cccc/providers.dart';
import 'package:cccc/routes/go_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

GoRouter buildRouter(WidgetRef ref) {
  return GoRouter(
    routes: $appRoutes,
    initialLocation: const SignInRoute().location,
    redirect: (context, state) async {
      final signInLocation = const SignInRoute().location;
      final goingToSignIn = state.subloc == signInLocation;

      final user = ref.watch(authStateChangesProvider).value;

      if (user == null && !goingToSignIn) {
        return const SignInRoute().location;
      }

      if (user != null && goingToSignIn) {
        final localAuth = ref.watch(localAuthenticationServiceProvider);
        final useLocalAuth = await localAuth.getUseLocalAuth();

        if (useLocalAuth && !localAuth.isAuthenticated) {
          return const LocalAuthenticationRoute().location;
        }

        return const HomeRoute().location;
      }

      return null;
    },
    observers: [MockNavigatorObserver()],
  );
}
