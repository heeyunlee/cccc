import 'package:cccc/model/plaid/transaction.dart';
import 'package:cccc/routes/adaptive_page_route.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/view/connect_with_plaid_screen.dart';
import 'package:cccc/view/home_screen.dart';
import 'package:cccc/view/settings_screen.dart';
import 'package:cccc/view/transactions_screen.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return adaptiveRoute(
          rootNavigator: true,
          maintainState: true,
          settings: settings,
          builder: (context) => const HomeScreen(),
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
      case RouteNames.transactions:
        final mapArgs = settings.arguments as List<Transaction>;
        // print('arguments = ${settings.arguments}');

        return adaptiveRoute(
          rootNavigator: false,
          maintainState: true,
          builder: (context) => TransactionsScreen(transactions: mapArgs),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
