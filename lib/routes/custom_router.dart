import 'package:cccc/routes/adaptive_page_route.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/view/connect_with_plaid_screen.dart';
import 'package:cccc/view/home.dart';
import 'package:cccc/view/settings_screen.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return adaptiveRoute(
          rootNavigator: true,
          maintainState: true,
          settings: settings,
          builder: (context) => const Home(),
        );
      case RouteNames.connectPlaid:
        return adaptiveRoute(
          rootNavigator: true,
          maintainState: true,
          settings: settings,
          builder: (context) => const ConnectWithPlaidScreen(),
        );
      case RouteNames.settings:
        return adaptiveRoute(
          rootNavigator: true,
          maintainState: true,
          settings: settings,
          builder: (context) => const SettingsScreen(),
        );
      default:
        return null;
    }
  }
}
