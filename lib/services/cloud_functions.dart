import 'dart:io';

import 'package:cccc/constants/cloud_functions_keys.dart';
import 'package:cccc/constants/keys.dart';
import 'package:cccc/constants/logger_init.dart';
import 'package:cccc/model/user.dart';
import 'package:cccc/view/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

import 'firebase_auth.dart';
import 'firestore_database.dart';

final cloudFunctionsProvider = Provider<CloudFunctions>((ref) {
  final auth = ref.watch(authProvider);
  final uid = auth.currentUser?.uid;

  final database = ref.watch(databaseProvider(uid));

  return CloudFunctions(auth: auth, database: database!);
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

  static Uri fetchTransactionsUri = Uri(
    scheme: 'https',
    host: Keys.cloudFunctionHost,
    path: CloudFunctionsKeys.fetchTransactionData,
  );

  Future<String?> getLinkToken(BuildContext context) async {
    try {
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
    } on Response catch (response) {
      if (response.statusCode == 404) {
        logger.e(response);

        showAdaptiveAlertDialog(
          context,
          title: 'An Error Occurred',
          content: 'An Error Occurred',
          defaultActionText: 'OK',
        );
      }
      throw showAdaptiveAlertDialog(
        context,
        title: 'An Error Occurred',
        content: 'An Error Occurred',
        defaultActionText: 'OK',
      );
    } on SocketException catch (e) {
      logger.e(e);

      showAdaptiveAlertDialog(
        context,
        title: 'An Error Occurred',
        content: 'An Error Occurred',
        defaultActionText: 'OK',
      );
    } catch (e) {
      logger.e(e);

      showAdaptiveAlertDialog(
        context,
        title: 'An Error Occurred',
        content: 'An Error Occurred',
        defaultActionText: 'OK',
      );
    }
  }

  void exchangePublicToken(
    BuildContext context, {
    required String publicToken,
  }) async {
    try {
      final uid = auth.currentUser!.uid;

      final response = await http.post(
        exchangePublicTokenUri,
        body: json.encode({
          'uid': uid,
          'public_token': publicToken,
        }),
      );

      logger.d('Response: ${response.body}');
    } on Response catch (response) {
      if (response.statusCode == 404) {
        logger.e(response);

        showAdaptiveAlertDialog(
          context,
          title: 'An Error Occurred',
          content: 'An Error Occurred',
          defaultActionText: 'OK',
        );
      }
      throw showAdaptiveAlertDialog(
        context,
        title: 'An Error Occurred',
        content: 'An Error Occurred',
        defaultActionText: 'OK',
      );
    } on SocketException catch (e) {
      logger.e(e);

      showAdaptiveAlertDialog(
        context,
        title: 'An Error Occurred',
        content: 'An Error Occurred',
        defaultActionText: 'OK',
      );
    } catch (e) {
      logger.e(e);

      showAdaptiveAlertDialog(
        context,
        title: 'An Error Occurred',
        content: 'An Error Occurred',
        defaultActionText: 'OK',
      );
    }
  }

  Future<void> fetchTransactionsData(BuildContext context, User user) async {
    logger.d('`fetchTransactionsData` function called');

    if (user.plaidAccessToken != null) {
      try {
        final now = DateTime.now();

        final startDate =
            user.lastPlaidSyncTime ?? now.subtract(const Duration(days: 60));

        final response = await http.post(
          fetchTransactionsUri,
          body: json.encode({
            'uid': user.uid,
            'start_date': startDate.toString(),
            'end_date': DateTime(now.year, now.month, now.day).toString(),
          }),
        );
        if (response.statusCode == 200) {
          final updatedUserData = {
            'lastPlaidSyncTime': DateTime.now(),
          };

          await database.updateUser(user, updatedUserData);

          logger.d('Response: ${response.statusCode}');
        }
      } on Response catch (response) {
        if (response.statusCode == 404) {
          logger.e(response);

          showAdaptiveAlertDialog(
            context,
            title: 'An Error Occurred',
            content: 'An Error Occurred',
            defaultActionText: 'OK',
          );
        }
        throw showAdaptiveAlertDialog(
          context,
          title: 'An Error Occurred',
          content: 'An Error Occurred',
          defaultActionText: 'OK',
        );
      } on SocketException catch (e) {
        logger.e('SocketException: $e');

        showAdaptiveAlertDialog(
          context,
          title: 'An Error Occurred',
          content: 'An Error Occurred',
          defaultActionText: 'OK',
        );
      } catch (e) {
        logger.e(e);

        showAdaptiveAlertDialog(
          context,
          title: 'An Error Occurred',
          content: 'An Error Occurred',
          defaultActionText: 'OK',
        );
      }
    }
    // } else {
    //   await Future.delayed(const Duration(seconds: 2));
    // }
  }
}
