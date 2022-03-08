import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/accounts_institution.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/view_models/account_detail_bottom_sheet_model.dart';
import 'package:cccc/view_models/account_detail_model.dart';
import 'package:cccc/view_models/choose_merchant_for_transaction_model.dart';
import 'package:cccc/view_models/connect_plaid_model.dart';
import 'package:cccc/view_models/home_model.dart';
import 'package:cccc/view_models/linked_accounts_model.dart';
import 'package:cccc/view_models/privacy_and_security_settings_model.dart';
import 'package:cccc/view_models/sign_in_model.dart';
import 'package:cccc/view_models/transaction_detail_screen_model.dart';
import 'package:cccc/widget_models/institution_card_model.dart';
import 'package:cccc/widget_models/scan_receipt_bottom_sheet_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'services/cloud_functions.dart';
import 'services/firebase_auth_service.dart';
import 'services/database.dart';
import 'services/image_picker_service.dart';
import 'services/local_authentication_service.dart';
import 'services/logger_init.dart';
import 'services/shared_preference_service.dart';

/// Creates [FirebaseAuthService] provider which deals with Firebase Authentication
final firebaseAuthProvider = Provider<FirebaseAuthService>(
  (ref) => FirebaseAuthService(),
);

/// Creates [CloudFunctions] provider that uses HTTP Requests to call Google
/// Cloud Functions written in Python
final cloudFunctionsProvider = Provider.autoDispose<CloudFunctions>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final database = ref.watch(databaseProvider);

  return CloudFunctions(auth: auth, database: database);
});

/// Creates [Database] provider that deals with Firebase Cloud Firestore
final databaseProvider = Provider.autoDispose<Database>(
  (ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final uid = auth.currentUser!.uid;

    logger.d('uid from [databaseProvider]: $uid');

    return Database(uid: uid);
  },
);

/// Creates [ImagePickerService] provider that deals with `ImagePicker` package
final imagePickerServiceProvider = Provider(
  (ref) => ImagePickerService(),
);

/// Creates [LocalAuthenticationService] provider that deals with local
/// authentication such as Fade ID or Fingerprint authentication
final localAuthenticationServiceProvider = ChangeNotifierProvider((ref) {
  final sharedPref = ref.watch(sharedPreferenceServiceProvider);

  return LocalAuthenticationService(sharedPref: sharedPref);
});

/// Creates [SharedPreferencesService] provider that deals with `SharedPreferences`
/// package
final sharedPreferenceServiceProvider = Provider((ref) {
  return SharedPreferencesService();
});

/// Creates [AccountDetailBottomSheetModel]
final accountDetailBottomSheetModelProvider = ChangeNotifierProvider.autoDispose
    .family<AccountDetailBottomSheetModel, Account>(
  (ref, account) => AccountDetailBottomSheetModel(
    functions: ref.watch(cloudFunctionsProvider),
    account: account,
  ),
);

/// Creates [AccountDetailModel] provider that manages the state of the
/// `AccountDetail` screen.
final accountDetailModelProvider =
    ChangeNotifierProvider.family.autoDispose<AccountDetailModel, Account>(
  (ref, account) {
    final database = ref.watch(databaseProvider);

    return AccountDetailModel(account: account, database: database);
  },
);

/// Creates [ChooseMerchantForTransactionModel] provider that manages the state
/// of the `ChooseMerchantForTransaction` screen.
final chooseMerchantForTransactionModelProvider = ChangeNotifierProvider
    .autoDispose
    .family<ChooseMerchantForTransactionModel, Transaction>(
  (ref, transaction) {
    final database = ref.watch(databaseProvider);

    return ChooseMerchantForTransactionModel(
      database: database,
      transaction: transaction,
    );
  },
);

/// Creates [ConnectPlaidModel] provider that manages the state of the
/// `ConnectPlaid` screen.
final connectPlaidModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final functions = ref.watch(cloudFunctionsProvider);

    return ConnectPlaidModel(functions: functions);
  },
);

/// Creates [HomeModel] provider that manages the state of the `Home` screen.
final homeModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final database = ref.watch(databaseProvider);
    final functions = ref.watch(cloudFunctionsProvider);

    return HomeModel(database: database, functions: functions);
  },
);

/// Creates [LinkedAccountsModel] provider that manages the state of the
/// `LinkedAccounts` screen.
final linkedAccountsModelProvider = ChangeNotifierProvider.autoDispose
    .family<LinkedAccountsModel, List<Account?>>(
  (ref, accounts) {
    final database = ref.watch(databaseProvider);

    return LinkedAccountsModel(accounts: accounts, database: database);
  },
);

/// Creates [PrivacyAndSecuritySettingsModel] provider that manages the state of
/// the `PrivacyAndSecuritySettings` screen
final privacyAndSecuritySettingsModelProvider = ChangeNotifierProvider((ref) {
  final sharedPref = SharedPreferencesService();
  final localAuth = LocalAuthenticationService(sharedPref: sharedPref);

  return PrivacyAndSecuritySettingsModel(localAuth: localAuth);
});

/// Creates [ScanReceiptBottomSheetModel] provider that manages the state of
/// `ScanReceiptBottomSheet` widget
final scanReceiptBottomSheetModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final imagePicker = ref.read(imagePickerServiceProvider);
    final functions = ref.watch(cloudFunctionsProvider);
    final database = ref.watch(databaseProvider);

    return ScanReceiptBottomSheetModel(
      imagePicker: imagePicker,
      functions: functions,
      database: database,
    );
  },
);

/// Creates [SignInModel] provider that manages the state of `SignIn` screen.
final signInModelProvider = ChangeNotifierProvider<SignInModel>(
  (ref) => SignInModel(
    auth: ref.watch(firebaseAuthProvider),
  ),
);

/// Creates [TransactionDetailModel] provider that manages the state of
/// `TransactionDetail` screen.
final transactionDetailModelProvider = ChangeNotifierProvider.autoDispose
    .family<TransactionDetailModel, Transaction>((ref, transaction) {
  final database = ref.watch(databaseProvider);

  return TransactionDetailModel(
    transaction: transaction,
    database: database,
  );
});

/// Creates a [InstitutionCardModel] provider that manages the state of
/// `InstitutionCard` widget
final institutionCardModelProvider = ChangeNotifierProvider.autoDispose
    .family<InstitutionCardModel, AccountsInstitution?>(
        (ref, accountsInstitution) {
  return InstitutionCardModel(
    functions: ref.watch(cloudFunctionsProvider),
    institution: accountsInstitution?.institution,
    accounts: accountsInstitution?.accounts,
  );
});
