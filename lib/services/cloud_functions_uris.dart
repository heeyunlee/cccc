import 'package:cccc/constants/cloud_functions_keys.dart';
import 'package:cccc/constants/cloud_function_host.dart';

class CloudFunctionsURIs {
  static Uri createLinkToken = Uri(
    scheme: 'https',
    host: CloudFunctionHost.host,
    path: CloudFunctionsKeys.createLinkToken,
  );

  static Uri linkAndConnect = Uri(
    scheme: 'https',
    host: CloudFunctionHost.host,
    path: CloudFunctionsKeys.linkAndConnect,
  );

  static Uri linkAndConnectUpdateMode = Uri(
    scheme: 'https',
    host: CloudFunctionHost.host,
    path: CloudFunctionsKeys.linkAndConnectUpdateMode,
  );

  static Uri transactionsRefresh = Uri(
    scheme: 'https',
    host: CloudFunctionHost.host,
    path: CloudFunctionsKeys.transactionsRefresh,
  );

  static Uri updateTransactionsWithImage = Uri(
    scheme: 'https',
    host: CloudFunctionHost.host,
    path: CloudFunctionsKeys.updateTransactionsWithImage,
  );

  static Uri processReceiptTexts = Uri(
    scheme: 'https',
    host: CloudFunctionHost.host,
    path: CloudFunctionsKeys.processReceiptTexts,
  );

  static Uri createLinkTokenUpdateMode = Uri(
    scheme: 'https',
    host: CloudFunctionHost.host,
    path: CloudFunctionsKeys.createLinkTokenUpdateMode,
  );

  static Uri unlinkAccount = Uri(
    scheme: 'https',
    host: CloudFunctionHost.host,
    path: CloudFunctionsKeys.unlinkAccount,
  );
}
