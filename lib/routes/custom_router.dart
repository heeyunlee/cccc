import 'package:cccc/connect_with_plaid_screen.dart';
import 'package:cccc/home.dart';
import 'package:cccc/routes/adaptive_page_route.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return adaptiveRoute(
          rootNavigator: true,
          builder: (context) => const Home(),
        );
      case RouteNames.connectPlaid:
        return adaptiveRoute(
          rootNavigator: true,
          builder: (context) => const ConnectWithPlaidScreen(),
        );
      default:
        return null;
    }
  }
}
