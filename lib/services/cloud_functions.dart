import 'package:cccc/models/receipt_response.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cloud_functions_uris.dart';
import 'firebase_auth.dart';
import 'firestore_database.dart';

final cloudFunctionsProvider = Provider<CloudFunctions>((ref) {
  final auth = ref.watch(authProvider);
  final uid = auth.currentUser?.uid;
  final database = ref.watch(databaseProvider(uid!));

  return CloudFunctions(auth: auth, database: database);
});

class CloudFunctions {
  CloudFunctions({
    required this.auth,
    required this.database,
  });

  final FirebaseAuthService auth;
  final FirestoreDatabase database;

  Future<Map<String, dynamic>> createLinkToken() async {
    final uid = auth.currentUser!.uid;

    final response = await http.post(
      CloudFunctionsURIs.createLinkToken,
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
      CloudFunctionsURIs.createLinkTokenUpdateMode,
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
      CloudFunctionsURIs.linkAndConnect,
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
      CloudFunctionsURIs.linkAndConnectUpdateMode,
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
      CloudFunctionsURIs.transactionsRefresh,
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

  Future<void> updateTransactionsData(
    BuildContext context,
    String? url,
  ) async {
    logger.d('`updateTransactionsData` function called');

    if (url != null) {
      logger.d('plaidAccessToken exists');

      final response = await http.post(
        CloudFunctionsURIs.updateTransactionsWithImage,
        body: json.encode({
          'url': url,
        }),
      );
      logger.d('Response: ${response.body}');
    }
  }

  Future<ReceiptResponse?> processReceiptTexts(
    BuildContext context, {
    String? rawTexts,
    required List<Map<String, dynamic>> textsWithOffsets,
  }) async {
    logger.d('`processReceiptTexts` function called');

    if (rawTexts != null) {
      logger.d('[rawTexts] exists \n$rawTexts');

      final response = await http.post(
        CloudFunctionsURIs.processReceiptTexts,
        body: json.encode({
          'raw_texts': rawTexts,
          'texts_with_offsets': textsWithOffsets,
        }),
      );
      logger.d('Response Body1 : ${response.body}');

      if (response.statusCode == 200) {
        final a = ReceiptResponse.fromJson(response.body);
        // final date = response.body;
        // final list = TransactionItems.fromJson(response.body);
        logger.d('Response Body2 : \n$a');

        return a;
      } else {
        logger.d('Response did not return correctly');
      }
    } else {
      logger.d('raw text was null');
    }
  }
}
