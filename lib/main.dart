import 'package:cccc/routes/build_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:logger/logger.dart';

import 'package:cccc/services/logger_init.dart';

import 'firebase_options.dart';
import 'styles/styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

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

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyAppWithProviderScope());
}

class MyAppWithProviderScope extends StatelessWidget {
  const MyAppWithProviderScope({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: MyApp());
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Init debugging [Logger] for Debug and Profile mode
    if (kDebugMode || kProfileMode) {
      initLogger(Level.debug);
    }

    final router = buildRouter(ref);

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
