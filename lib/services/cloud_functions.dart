import 'package:cccc/constants/cloud_functions_keys.dart';
import 'package:cccc/constants/keys.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  static Uri createLinkTokenUri = Uri(
    scheme: 'https',
    host: Keys.cloudFunctionHost,
    path: CloudFunctionsKeys.createLinkToken,
  );

  static Uri exchangePublicTokenUri = Uri(
    scheme: 'https',
    host: Keys.cloudFunctionHost,
    path: CloudFunctionsKeys.exchangePublicToken,
  );

  static Uri getTransactionsUri = Uri(
    scheme: 'https',
    host: Keys.cloudFunctionHost,
    path: CloudFunctionsKeys.getTransactions,
  );

  Future<String?> getLinkToken() async {
    final uid = auth.currentUser!.uid;

    final response = await http.post(
      createLinkTokenUri,
      body: json.encode({
        'uid': uid,
      }),
    );

    final data = json.decode(response.body);
    final linkToken = data['link_token'] as String;

    return linkToken;
  }

  void exchangePublicToken(String publicToken, List<String> accountIds) async {
    final uid = auth.currentUser!.uid;

    final response = await http.post(
      exchangePublicTokenUri,
      body: json.encode({
        'uid': uid,
        'public_token': publicToken,
        'account_ids': accountIds,
      }),
    );

    logger.d('Response: ${response.body}');
  }

  Future<void> getTransactions(BuildContext context, User user) async {
    logger.d('`fetchTransactionsData` function called');

    if (user.plaidAccessToken != null) {
      logger.d('plaidAccessToken exists');

      final now = DateTime.now();

      final startDate =
          user.lastPlaidSyncTime ?? now.subtract(const Duration(days: 60));

      final response = await http.post(
        getTransactionsUri,
        body: json.encode({
          'uid': user.uid,
          'start_date': startDate.toString(),
          'end_date': DateTime(now.year, now.month, now.day).toString(),
        }),
      );
      logger.d('Response: ${response.body}');

      if (response.statusCode == 200) {
        final updatedUserData = {
          'lastPlaidSyncTime': DateTime.now(),
        };

        await database.updateUser(user, updatedUserData);
      }
    } else {
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
