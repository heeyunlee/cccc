import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/routes/adaptive_page_route.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/views/details/account_detail.dart';
import 'package:cccc/views/details/choose_merchant_for_transaction.dart';
import 'package:cccc/views/add_account/add_account.dart';
import 'package:cccc/views/home/home.dart';
import 'package:cccc/views/settings/linked_accounts.dart';
import 'package:cccc/views/settings/local_authenticate_screen.dart';
import 'package:cccc/views/settings/privacy_and_security_settings.dart';
import 'package:cccc/views/scan_receipt/scan_receipt.dart';
import 'package:cccc/views/settings/settings.dart';
import 'package:cccc/views/details/transaction_detail.dart';
import 'package:cccc/views/home/all_transactions.dart';
import 'package:flutter/material.dart';

/// Creates a custom route setting so that based on different [RouteNames],
/// different screen is build when routing.
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
          builder: (context) => const AddAccount(),
        );
      case RouteNames.settings:
        return adaptiveRoute(
          rootNavigator: true,
          maintainState: true,
          settings: settings,
          builder: (context) => const Settings(),
        );
      case RouteNames.allTransactions:
        return adaptiveRoute(
          rootNavigator: false,
          maintainState: true,
          builder: (context) => const AllTransactions(),
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
      case RouteNames.linkedAccounts:
        return adaptiveRoute(
          rootNavigator: false,
          maintainState: true,
          builder: (context) => const LinkedAccounts(),
          settings: settings,
        );
      case RouteNames.chooseMerchant:
        final arg = settings.arguments as Transaction;

        return adaptiveRoute(
          rootNavigator: true,
          maintainState: true,
          builder: (context) => ChooseMerchantForTransaction(transaction: arg),
          settings: settings,
        );
      case RouteNames.privacyAndSecurity:
        return adaptiveRoute(
          rootNavigator: false,
          maintainState: true,
          builder: (context) => const PrivacyAndSecuritySettings(),
          settings: settings,
        );
      case RouteNames.authenticate:
        return adaptiveRoute(
          rootNavigator: true,
          maintainState: true,
          builder: (context) => const LocalAuthenticationScreen(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
