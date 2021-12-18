import 'package:cccc/constants/logger_init.dart';
import 'package:cccc/routes/custom_router.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/theme/custom_theme.dart';
import 'package:cccc/view/home.dart';
import 'package:cccc/view/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class MyMaterialApp extends ConsumerWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kDebugMode || kProfileMode) {
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

    final auth = ref.watch(authProvider);

    return MaterialApp(
      title: 'Credit Card Calorie Counter',
      home: StreamBuilder<fire_auth.User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;

            if (user != null) {
              return const Home();
            } else {
              logger.d('user does NOT exist');

              return const SignInScreen();
            }
          }

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),

      // home: auth.authStateChanges().when(
      //   data: (user) {
      //     if (user == null) {
      //       return const SignInViewScreen();
      //     } else {
      //       return const Home();
      //     }
      //   },
      //   loading: () => const Scaffold(
      //     body: Center(
      //       child: CircularProgressIndicator(),
      //     ),
      //   ),
      //   error: (e, _) => const Scaffold(
      //     body: Center(
      //       child: Text('Error'),
      //     ),
      //   ),
      // ),
      theme: CustomTheme.theme,
      onGenerateRoute: CustomRouter.onGenerateRoute,
    );
  }
}
