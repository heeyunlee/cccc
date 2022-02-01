import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/routes/adaptive_page_route.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/view/account_detail.dart';
import 'package:cccc/view/connect_plaid.dart';
import 'package:cccc/view/home.dart';
import 'package:cccc/view/scan_receipt.dart';
import 'package:cccc/view/settings.dart';
import 'package:cccc/view/transaction_detail.dart';
import 'package:cccc/view/all_transactions.dart';
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
      case RouteNames.addAccounts:
        return adaptiveRoute(
          rootNavigator: true,
          maintainState: true,
          settings: settings,
          builder: (context) => const ConnectPlaid(),
        );
      case RouteNames.settings:
        return adaptiveRoute(
          rootNavigator: true,
          maintainState: true,
          settings: settings,
          builder: (context) => const Settings(),
        );
      case RouteNames.transactions:
        final mapArgs = settings.arguments as List<Transaction>;

        return adaptiveRoute(
          rootNavigator: false,
          maintainState: true,
          builder: (context) => AllTransactions(transactions: mapArgs),
          settings: settings,
        );
      case RouteNames.transaction:
        final args = settings.arguments as Transaction;

        return adaptiveRoute(
          rootNavigator: false,
          maintainState: true,
          builder: (context) => TransactionDetail(transaction: args),
          settings: settings,
        );
      case RouteNames.account:
        final args = settings.arguments as Map<String, dynamic>;
        final account = args['account'] as Account;
        final institution = args['institution'] as Institution?;

        return adaptiveRoute(
          rootNavigator: false,
          maintainState: true,
          builder: (context) => AccountDetail(
            account: account,
            institution: institution,
          ),
          settings: settings,
        );
      case RouteNames.scanReceipts:
        final args = settings.arguments as Transaction?;

        return adaptiveRoute(
          rootNavigator: true,
          maintainState: true,
          builder: (context) => ScanReceipt(transaction: args),
          settings: settings,
        );

      default:
        return null;
    }
  }
}
