import 'package:cccc/services/logger_init.dart';
import 'package:cccc/routes/custom_router.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/theme/custom_theme.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';
import 'package:cccc/view/home_screen.dart';
import 'package:cccc/view/sign_in_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyMaterialApp extends ConsumerWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final auth = ref.watch(authProvider);

    return MaterialApp(
      useInheritedMediaQuery: kReleaseMode ? false : true,
      locale: kReleaseMode ? null : DevicePreview.locale(context),
      builder: kReleaseMode ? null : DevicePreview.appBuilder,
      title: 'Credit Card Calorie Counter',
      home: CustomStreamBuilder<fire_auth.User?>(
        stream: auth.authStateChanges(),
        emptyWidget: const SignInScreen(),
        builder: (context, user) {
          if (user != null) {
            return const HomeScreen();
          } else {
            logger.d('user does NOT exist. Opening [SignIn] Screen');

            return const SignInScreen();
          }
        },
      ),
      theme: CustomTheme.theme,
      onGenerateRoute: CustomRouter.onGenerateRoute,
    );
  }
}
