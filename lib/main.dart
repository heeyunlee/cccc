import 'package:cccc/services/logger_init.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'firebase_options.dart';
import 'widgets/auth_states_widget_builder.dart';
import 'routes/custom_router.dart';
import 'styles/styles.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    return MaterialApp(
      navigatorObservers: [routeObserver],
      useInheritedMediaQuery: true,
      title: 'CCCC: Credit Card Calorie Counter',
      home: const AuthStatesWidgetBuilder(),
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
      onGenerateRoute: CustomRouter.onGenerateRoute,
    );
  }
}
