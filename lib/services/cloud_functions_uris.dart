import 'package:cccc/constants/cloud_functions_keys.dart';
import 'package:cccc/constants/cloud_function_host.dart';

class CloudFunctionsURIs {
  static Uri linkTokenCreate = Uri(
    scheme: 'https',
    host: CloudFunctionHost.host,
    path: CloudFunctionsKeys.linkTokenCreate,
  );

  static Uri linkAndConnect = Uri(
    scheme: 'https',
    host: CloudFunctionHost.host,
    path: CloudFunctionsKeys.linkAndConnect,
  );

  // transactionRefresh URI
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
}
