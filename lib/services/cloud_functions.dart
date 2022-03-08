import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cccc/constants/cloud_function_host.dart';
import 'package:cccc/constants/cloud_functions_keys.dart';
import 'package:cccc/models/receipt_response.dart';
import 'package:cccc/models/user.dart';
import 'package:cccc/services/logger_init.dart';

import 'database.dart';
import 'firebase_auth_service.dart';

class CloudFunctions {
  CloudFunctions({
    required this.auth,
    required this.database,
  });

  final FirebaseAuthService auth;
  final Database database;

  Future<Map<String, dynamic>> createLinkToken() async {
    final uid = auth.currentUser!.uid;

    final response = await http.post(
      _CloudFunctionsURIs.createLinkToken,
      body: json.encode({
        'uid': uid,
      }),
    );

    final responseBody = json.decode(response.body) as Map<String, dynamic>;
    logger.d('response body: $responseBody');

    return responseBody;
  }

  Future<Map<String, dynamic>> createLinkTokenUpdateMode(
    String institutionId,
  ) async {
    final uid = auth.currentUser!.uid;

    final response = await http.post(
      _CloudFunctionsURIs.createLinkTokenUpdateMode,
      body: json.encode({
        'uid': uid,
        'institution_id': institutionId,
      }),
    );

    final responseBody = json.decode(response.body) as Map<String, dynamic>;
    logger.d('response body: $responseBody');

    return responseBody;
  }

  Future<Map<String, dynamic>> linkAndConnect(
    String publicToken,
    String institutionId,
  ) async {
    final uid = auth.currentUser!.uid;

    final response = await http.post(
      _CloudFunctionsURIs.linkAndConnect,
      body: json.encode({
        'uid': uid,
        'public_token': publicToken,
        'institution_id': institutionId,
      }),
    );

    final responseBody = json.decode(response.body) as Map<String, dynamic>;
    logger.d('response body: $responseBody');

    return responseBody;
  }

  Future<Map<String, dynamic>> linkAndConnectUpdateMode(
    String publicToken,
    String institutionId,
  ) async {
    final uid = auth.currentUser!.uid;

    final response = await http.post(
      _CloudFunctionsURIs.linkAndConnectUpdateMode,
      body: json.encode({
        'uid': uid,
        'public_token': publicToken,
        'institution_id': institutionId,
      }),
    );

    final responseBody = json.decode(response.body) as Map<String, dynamic>;
    logger.d('response body: $responseBody');

    return responseBody;
  }

  Future<http.Response> transactionsRefresh(User user) async {
    logger.d('`transactionsRefresh` function called');

    final response = await http.post(
      _CloudFunctionsURIs.transactionsRefresh,
      body: json.encode({
        'uid': user.uid,
      }),
    );

    logger.d('''
    Response: 
    headers: ${response.headers}
    statusCode: ${response.statusCode}
    body: ${response.body}
    ''');

    if (response.statusCode == 200) {
      final updatedUserData = {
        'lastPlaidSyncTime': DateTime.now(),
      };

      await database.updateUser(user, updatedUserData);

      return response;
    } else {
      return response;
    }
  }

  Future<void> updateTransactionsData(String? url) async {
    logger.d('`updateTransactionsData` function called');

    if (url != null) {
      logger.d('plaidAccessToken exists');

      final response = await http.post(
        _CloudFunctionsURIs.updateTransactionsWithImage,
        body: json.encode({
          'url': url,
        }),
      );
      logger.d('Response: ${response.body}');
    }
  }

  Future<ReceiptResponse?> processReceiptTexts({
    String? rawTexts,
    required List<Map<String, dynamic>> textsWithOffsets,
  }) async {
    logger.d('`processReceiptTexts` function called');

    if (rawTexts != null) {
      logger.d('[rawTexts] exists \n$rawTexts');

      final response = await http.post(
        _CloudFunctionsURIs.processReceiptTexts,
        body: json.encode({
          'raw_texts': rawTexts,
          'texts_with_offsets': textsWithOffsets,
        }),
      );

      return ReceiptResponse.fromJson(response.body);
    } else {
      logger.d('raw text was null');
    }
    return null;
  }

  Future<http.Response> unlinkAccount(String? institutionId) async {
    final response = await http.post(
      _CloudFunctionsURIs.unlinkAccount,
      body: json.encode({
        'uid': auth.currentUser!.uid,
        'institution_id': institutionId,
      }),
    );

    logger.d('unlinkAccount response: ${response.body}');

    return response;
  }
}

class _CloudFunctionsURIs {
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
