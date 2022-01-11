import 'package:cccc/services/logger_init.dart';
import 'package:cccc/routes/custom_router.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/theme/custom_theme.dart';
import 'package:cccc/view/splash_screen.dart';
import 'package:cccc/view/home_screen.dart';
import 'package:cccc/view/sign_in_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyMaterialApp extends ConsumerWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return MaterialApp(
      useInheritedMediaQuery: kReleaseMode ? false : true,
      locale: kReleaseMode ? null : DevicePreview.locale(context),
      builder: kReleaseMode ? null : DevicePreview.appBuilder,
      title: 'Credit Card Calorie Counter',
      home: StreamBuilder<fire_auth.User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            logger.e(snapshot.error);

            return const Center(
              child: Text('An Error Occurred'),
            );
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.done:
                return const SplashScreen();
              // return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return _buildWidget(snapshot.data);
            }
          }
        },
      ),
      theme: CustomTheme.theme,
      onGenerateRoute: CustomRouter.onGenerateRoute,
    );
  }

  Widget _buildWidget(fire_auth.User? user) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: user != null ? const HomeScreen() : const SignInScreen(),
    );
  }
}
