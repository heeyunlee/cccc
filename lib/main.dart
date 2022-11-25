import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import 'package:cccc/providers.dart';
import 'package:cccc/routes/go_routes.dart';
import 'package:cccc/services/logger_init.dart';

import 'firebase_options.dart';
import 'styles/styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Disable landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    /// Set setSystemUIOverlayStyle for Android
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.black87,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    /// Make Android fullscreen
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );

    /// Init debugging [Logger] for Debug and Profile mode
    if (kDebugMode || kProfileMode) {
      initLogger(Level.debug);
    }

    final router = GoRouter(
      routes: $appRoutes,
      redirect: (context, state) {
        final location = state.location;

        final user = ref.watch(authStateChangesProvider);

        final redirectedPath = user.when(
          data: (user) {
            if (user != null && !location.startsWith('/home')) {
              final localAuth = ref.watch(localAuthenticationServiceProvider);

              final useLocalAuth = ref.watch(useLocalAuthFutureProvider).when(
                    data: (value) => value,
                    error: (error, _) => false,
                    loading: () => false,
                  );

              if (useLocalAuth && !localAuth.isAuthenticated) {
                return '/home/localAuthentication';
              }

              return '/home';
            } else if (user == null && !location.startsWith('/sign-in')) {
              return '/sign-in';
            }
          },
          error: (error, _) => null,
          loading: () => null,
        );

        return redirectedPath;
      },
    );

    return MaterialApp.router(
      routerConfig: router,
      useInheritedMediaQuery: true,
      title: 'CCCC: Credit Card Calorie Counter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Themes.primarySwatch,
          brightness: Brightness.dark,
        ),
        dividerColor: Colors.transparent,
        primaryColor: ThemeColors.primary500,
        scaffoldBackgroundColor: Colors.black,
        textTheme: Themes.text,
        listTileTheme: Themes.listTile,
        appBarTheme: Themes.appBar,
        bottomSheetTheme: Themes.bottomSheet,
        cardTheme: Themes.card,
        dividerTheme: Themes.divider,
      ),
    );
  }
}
