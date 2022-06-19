import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/providers.dart';
import 'package:cccc/routes/extra.dart';
import 'package:cccc/views/add_account/add_account.dart';
import 'package:cccc/views/details/account_detail.dart';
import 'package:cccc/views/details/choose_merchant_for_transaction.dart';
import 'package:cccc/views/details/transaction_detail.dart';
import 'package:cccc/views/home/home.dart';
import 'package:cccc/views/home/transactions_screen.dart';
import 'package:cccc/views/scan_receipt/scan_receipt.dart';
import 'package:cccc/views/settings/linked_accounts.dart';
import 'package:cccc/views/settings/local_authenticate_screen.dart';
import 'package:cccc/views/settings/privacy_and_security_settings.dart';
import 'package:cccc/views/settings/settings.dart';
import 'package:cccc/views/sign_in/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'adaptive_page_route.dart';

enum AppRoutes {
  initial,
  home,
  signIn,
  settings,
  addAccount,
  accountDetails,
  chooseMerchant,
  transactionDetails,
  transactions,
  scanReceipts,
  linkedAccounts,
  localAuthentication,
  privacyAndSecurity,
}

GoRouter buildGoRouter(BuildContext context, WidgetRef ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    urlPathStrategy: UrlPathStrategy.path,
    routes: [
      buildGoRoutes(AppRoutes.initial, ref: ref),
      buildGoRoutes(AppRoutes.signIn),
      buildGoRoutes(
        AppRoutes.home,
        ref: ref,
        routes: [
          buildGoRoutes(AppRoutes.addAccount),
          buildGoRoutes(AppRoutes.accountDetails),
          buildGoRoutes(AppRoutes.chooseMerchant),
          buildGoRoutes(AppRoutes.transactionDetails),
          buildGoRoutes(AppRoutes.transactions),
          buildGoRoutes(AppRoutes.scanReceipts),
          buildGoRoutes(AppRoutes.localAuthentication),
          buildGoRoutes(
            AppRoutes.settings,
            routes: [
              buildGoRoutes(AppRoutes.linkedAccounts),
              buildGoRoutes(AppRoutes.privacyAndSecurity),
            ],
          ),
        ],
      ),
    ],
  );
}

GoRoute buildGoRoutes(
  AppRoutes appRoutes, {
  List<GoRoute> routes = const [],
  WidgetRef? ref,
  BuildContext? context,
}) {
  switch (appRoutes) {
    case AppRoutes.initial:
      return GoRoute(
        path: '/',
        redirect: (state) {
          if (ref == null) return null;

          final user = ref.watch(authStateChangesProvider);

          final redirectedPath = user.when(
            data: (user) {
              if (user != null) {
                return '/home';
              } else {
                return '/signIn';
              }
            },
            error: (error, _) => null,
            loading: () => null,
          );

          return redirectedPath;
        },
      );
    case AppRoutes.home:
      return GoRoute(
          path: '/${AppRoutes.home.name}',
          name: AppRoutes.home.name,
          routes: routes,
          pageBuilder: (context, state) {
            return adaptivePage(
              context,
              name: appRoutes.name,
              fullscreenDialog: true,
              key: state.pageKey,
              child: const Home(),
            );
          },
          redirect: (state) {
            if (ref == null) return null;

            final localAuth = ref.watch(localAuthenticationServiceProvider);

            final useLocalAuth = ref.watch(useLocalAuthFutureProvider).when(
                  data: (value) => value,
                  error: (error, _) => false,
                  loading: () => false,
                );

            if (useLocalAuth && !localAuth.isAuthenticated) {
              return '/home/${AppRoutes.localAuthentication.name}';
            }

            return null;
          });

    case AppRoutes.signIn:
      return GoRoute(
        path: '/${AppRoutes.signIn.name}',
        name: AppRoutes.signIn.name,
        routes: routes,
        pageBuilder: (context, state) {
          return adaptivePage(
            context,
            child: const SignIn(),
          );
        },
      );

    case AppRoutes.settings:
      return GoRoute(
        path: AppRoutes.settings.name,
        name: AppRoutes.settings.name,
        routes: routes,
        pageBuilder: (context, state) {
          return adaptivePage(
            context,
            child: const Settings(),
          );
        },
      );

    case AppRoutes.addAccount:
      return GoRoute(
        path: AppRoutes.addAccount.name,
        name: AppRoutes.addAccount.name,
        routes: routes,
        pageBuilder: (context, state) {
          return adaptivePage(
            context,
            child: const AddAccount(),
          );
        },
      );

    case AppRoutes.accountDetails:
      return GoRoute(
        path: '${AppRoutes.accountDetails.name}/:accountId',
        name: AppRoutes.accountDetails.name,
        routes: routes,
        pageBuilder: (context, state) {
          final extra = state.extra as AccountDetailsScreenExtra;

          return adaptivePage(
            context,
            child: AccountDetail(
              account: extra.account,
              institution: extra.institution,
            ),
          );
        },
      );

    case AppRoutes.chooseMerchant:
      return GoRoute(
        path: AppRoutes.chooseMerchant.name,
        name: AppRoutes.chooseMerchant.name,
        routes: routes,
        pageBuilder: (context, state) {
          final extra = state.extra as Transaction;

          return adaptivePage(
            context,
            child: ChooseMerchantForTransaction(
              transaction: extra,
            ),
          );
        },
      );

    case AppRoutes.transactionDetails:
      return GoRoute(
        path: '${AppRoutes.transactionDetails.name}/:transactionId',
        name: AppRoutes.transactionDetails.name,
        routes: routes,
        pageBuilder: (context, state) {
          final extra = state.extra as Transaction;

          return adaptivePage(
            context,
            child: TransactionDetails(
              transaction: extra,
            ),
          );
        },
      );

    case AppRoutes.transactions:
      return GoRoute(
        path: AppRoutes.transactions.name,
        name: AppRoutes.transactions.name,
        routes: routes,
        pageBuilder: (context, state) {
          return adaptivePage(
            context,
            child: const TransactionsScreen(),
          );
        },
      );

    case AppRoutes.scanReceipts:
      return GoRoute(
        path: AppRoutes.scanReceipts.name,
        name: AppRoutes.scanReceipts.name,
        routes: routes,
        pageBuilder: (context, state) {
          final extra = state.extra as Transaction?;

          return adaptivePage(
            context,
            child: ScanReceipt(
              transaction: extra,
            ),
          );
        },
      );

    case AppRoutes.linkedAccounts:
      return GoRoute(
        path: AppRoutes.linkedAccounts.name,
        name: AppRoutes.linkedAccounts.name,
        routes: routes,
        pageBuilder: (context, state) {
          return adaptivePage(
            context,
            child: const LinkedAccounts(),
          );
        },
      );

    case AppRoutes.localAuthentication:
      return GoRoute(
        path: AppRoutes.localAuthentication.name,
        name: AppRoutes.localAuthentication.name,
        routes: routes,
        pageBuilder: (context, state) {
          return adaptivePage(
            context,
            child: const LocalAuthenticationScreen(),
          );
        },
      );

    case AppRoutes.privacyAndSecurity:
      return GoRoute(
        path: AppRoutes.privacyAndSecurity.name,
        name: AppRoutes.privacyAndSecurity.name,
        routes: routes,
        pageBuilder: (context, state) {
          return adaptivePage(
            context,
            name: AppRoutes.privacyAndSecurity.name,
            child: const PrivacyAndSecuritySettings(),
          );
        },
      );
  }
}
