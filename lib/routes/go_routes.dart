import 'package:cccc/views/add_account/add_account_screen.dart';
import 'package:cccc/views/details/account_details_screen.dart';
import 'package:cccc/views/details/choose_merchant_for_transaction.dart';
import 'package:cccc/views/details/transaction_detail_screen.dart';
import 'package:cccc/views/home/home_screen.dart';
import 'package:cccc/views/home/transactions_screen.dart';
import 'package:cccc/views/scan_receipt/scan_receipt_screen.dart';
import 'package:cccc/views/settings/linked_accounts_screen.dart';
import 'package:cccc/views/settings/local_authenticate_screen.dart';
import 'package:cccc/views/settings/privacy_and_security_screen.dart';
import 'package:cccc/views/settings/settings_screen.dart';
import 'package:cccc/views/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'adaptive_page_route.dart';

part 'go_routes.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/home',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<AddAccountRoute>(path: 'add-account'),
    TypedGoRoute<LocalAuthenticationRoute>(path: 'local-authentication'),
    TypedGoRoute<SettingsRoute>(
      path: 'settings',
      routes: [
        TypedGoRoute<PrivacyAndSecurityRoute>(path: 'privacy-and-security'),
      ],
    ),
    TypedGoRoute<LinkedAccountsRoute>(path: 'linked-accounts'),
    TypedGoRoute<AccountDetailsRoute>(path: 'accounts/:accountId'),
    TypedGoRoute<ChooseMerchantRoute>(
      path: 'choose-merchant/:transactionId/:id',
    ),
    TypedGoRoute<TransactionsRoute>(path: 'transactions'),
    TypedGoRoute<TransactionDetailsRoute>(path: 'transactions/:transactionId'),
    TypedGoRoute<ScanReceiptRoute>(path: 'scan-receipt'),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return adaptivePage(
      context,
      key: state.pageKey,
      fullscreenDialog: true,
      name: 'home',
      child: const HomeScreen(),
    );
  }
}

@TypedGoRoute<SignInRoute>(path: '/sign-in')
class SignInRoute extends GoRouteData {
  const SignInRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return adaptivePage(
      context,
      key: state.pageKey,
      fullscreenDialog: true,
      name: 'signIn',
      child: const SignInScreen(),
    );
  }
}

class AddAccountRoute extends GoRouteData {
  const AddAccountRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return adaptivePage(
      context,
      key: state.pageKey,
      fullscreenDialog: false,
      name: 'addAccount',
      child: const AddAccountScreen(),
    );
  }
}

class LocalAuthenticationRoute extends GoRouteData {
  const LocalAuthenticationRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return adaptivePage(
      context,
      key: state.pageKey,
      fullscreenDialog: true,
      name: 'localAuthentication',
      child: const LocalAuthenticationScreen(),
    );
  }
}

class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return adaptivePage(
      context,
      key: state.pageKey,
      fullscreenDialog: true,
      name: 'settings',
      child: const SettingsScreen(),
    );
  }
}

class AccountDetailsRoute extends GoRouteData {
  const AccountDetailsRoute(this.accountId);

  final String accountId;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return adaptivePage(
      context,
      key: state.pageKey,
      fullscreenDialog: true,
      name: 'settings',
      child: AccountDetailScreen(accountId: accountId),
    );
  }
}

class ChooseMerchantRoute extends GoRouteData {
  const ChooseMerchantRoute({
    required this.transactionId,
    required this.id,
  });

  final String transactionId;
  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return adaptivePage(
      context,
      key: state.pageKey,
      fullscreenDialog: false,
      name: 'chhoseMerchant',
      child: ChooseMerchantForTransactionScreen(
        transactionId: transactionId,
        id: id,
      ),
    );
  }
}

class TransactionsRoute extends GoRouteData {
  const TransactionsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return adaptivePage(
      context,
      key: state.pageKey,
      fullscreenDialog: false,
      name: 'transactions',
      child: const TransactionsScreen(),
    );
  }
}

class TransactionDetailsRoute extends GoRouteData {
  const TransactionDetailsRoute({required this.transactionId});

  final String transactionId;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return adaptivePage(
      context,
      key: state.pageKey,
      fullscreenDialog: false,
      name: 'transactionDetails',
      child: TransactionDetailsScreen(transactionId: transactionId),
    );
  }
}

class ScanReceiptRoute extends GoRouteData {
  const ScanReceiptRoute({this.transactionId});

  final String? transactionId;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return adaptivePage(
      context,
      key: state.pageKey,
      fullscreenDialog: false,
      name: 'scanReceipt',
      child: const ScanReceiptScreen(),
    );
  }
}

class LinkedAccountsRoute extends GoRouteData {
  const LinkedAccountsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return adaptivePage(
      context,
      key: state.pageKey,
      fullscreenDialog: false,
      name: 'linkedAccounts',
      child: const LinkedAccountsScreen(),
    );
  }
}

class PrivacyAndSecurityRoute extends GoRouteData {
  const PrivacyAndSecurityRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return adaptivePage(
      context,
      key: state.pageKey,
      fullscreenDialog: false,
      name: 'privacyAndSecurity',
      child: const PrivacyAndSecurityScreen(),
    );
  }
}
