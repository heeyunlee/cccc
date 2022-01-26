import 'package:cccc/constants/cloud_functions_keys.dart';
import 'package:cccc/constants/keys.dart';

class CloudFunctionsURIs {
  static Uri createLinkToken = Uri(
    scheme: 'https',
    host: Keys.cloudFunctionHost,
    path: CloudFunctionsKeys.createLinkToken,
  );

  static Uri exchangePublicTokenAndUpdateAccounts = Uri(
    scheme: 'https',
    host: Keys.cloudFunctionHost,
    path: CloudFunctionsKeys.exchangePublicTokenAndUpdateAccounts,
  );

  // transactionRefresh URI
  static Uri transactionsRefresh = Uri(
    scheme: 'https',
    host: Keys.cloudFunctionHost,
    path: CloudFunctionsKeys.transactionsRefresh,
  );

  static Uri updateTransactionsWithImage = Uri(
    scheme: 'https',
    host: Keys.cloudFunctionHost,
    path: CloudFunctionsKeys.updateTransactionsWithImage,
  );

  static Uri processReceiptTexts = Uri(
    scheme: 'https',
    host: Keys.cloudFunctionHost,
    path: CloudFunctionsKeys.processReceiptTexts,
  );
}
