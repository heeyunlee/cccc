// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<GoRoute> get $appRoutes => [
      $homeRoute,
      $signInRoute,
    ];

GoRoute get $homeRoute => GoRouteData.$route(
      path: '/home',
      factory: $HomeRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'add-account',
          factory: $AddAccountRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'local-authentication',
          factory: $LocalAuthenticationRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'settings',
          factory: $SettingsRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'privacy-and-security',
              factory: $PrivacyAndSecurityRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'linked-accounts',
          factory: $LinkedAccountsRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'accounts/:accountId',
          factory: $AccountDetailsRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'choose-merchant/:transactionId/:id',
          factory: $ChooseMerchantRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'transactions',
          factory: $TransactionsRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'transactions/:transactionId',
          factory: $TransactionDetailsRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'scan-receipt',
          factory: $ScanReceiptRouteExtension._fromState,
        ),
      ],
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/home',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $AddAccountRouteExtension on AddAccountRoute {
  static AddAccountRoute _fromState(GoRouterState state) =>
      const AddAccountRoute();

  String get location => GoRouteData.$location(
        '/home/add-account',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $LocalAuthenticationRouteExtension on LocalAuthenticationRoute {
  static LocalAuthenticationRoute _fromState(GoRouterState state) =>
      const LocalAuthenticationRoute();

  String get location => GoRouteData.$location(
        '/home/local-authentication',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $SettingsRouteExtension on SettingsRoute {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  String get location => GoRouteData.$location(
        '/home/settings',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $PrivacyAndSecurityRouteExtension on PrivacyAndSecurityRoute {
  static PrivacyAndSecurityRoute _fromState(GoRouterState state) =>
      const PrivacyAndSecurityRoute();

  String get location => GoRouteData.$location(
        '/home/settings/privacy-and-security',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $LinkedAccountsRouteExtension on LinkedAccountsRoute {
  static LinkedAccountsRoute _fromState(GoRouterState state) =>
      const LinkedAccountsRoute();

  String get location => GoRouteData.$location(
        '/home/linked-accounts',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $AccountDetailsRouteExtension on AccountDetailsRoute {
  static AccountDetailsRoute _fromState(GoRouterState state) =>
      AccountDetailsRoute(
        state.params['accountId']!,
      );

  String get location => GoRouteData.$location(
        '/home/accounts/${Uri.encodeComponent(accountId)}',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $ChooseMerchantRouteExtension on ChooseMerchantRoute {
  static ChooseMerchantRoute _fromState(GoRouterState state) =>
      ChooseMerchantRoute(
        transactionId: state.params['transactionId']!,
        id: int.parse(state.params['id']!),
      );

  String get location => GoRouteData.$location(
        '/home/choose-merchant/${Uri.encodeComponent(transactionId)}/${Uri.encodeComponent(id.toString())}',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $TransactionsRouteExtension on TransactionsRoute {
  static TransactionsRoute _fromState(GoRouterState state) =>
      const TransactionsRoute();

  String get location => GoRouteData.$location(
        '/home/transactions',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $TransactionDetailsRouteExtension on TransactionDetailsRoute {
  static TransactionDetailsRoute _fromState(GoRouterState state) =>
      TransactionDetailsRoute(
        transactionId: state.params['transactionId']!,
      );

  String get location => GoRouteData.$location(
        '/home/transactions/${Uri.encodeComponent(transactionId)}',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $ScanReceiptRouteExtension on ScanReceiptRoute {
  static ScanReceiptRoute _fromState(GoRouterState state) => ScanReceiptRoute(
        transactionId: state.queryParams['transaction-id'],
      );

  String get location => GoRouteData.$location(
        '/home/scan-receipt',
        queryParams: {
          if (transactionId != null) 'transaction-id': transactionId!,
        },
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

GoRoute get $signInRoute => GoRouteData.$route(
      path: '/sign-in',
      factory: $SignInRouteExtension._fromState,
    );

extension $SignInRouteExtension on SignInRoute {
  static SignInRoute _fromState(GoRouterState state) => const SignInRoute();

  String get location => GoRouteData.$location(
        '/sign-in',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}
