import 'package:cccc/home.dart';
import 'package:cccc/routes/custom_router.dart';
import 'package:cccc/theme/custom_theme.dart';
import 'package:cccc/utils/logger_init.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      initLogger(Level.debug);
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );

    return MaterialApp(
      title: 'Credit Card Calorie Counter',
      home: const Home(),
      theme: CustomTheme.theme,
      onGenerateRoute: CustomRouter.onGenerateRoute,
    );
  }
}
