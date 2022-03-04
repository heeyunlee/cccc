import 'dart:io';
import 'package:cccc/models/enum/account_type.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/models/user.dart';
import 'package:cccc/services/cloud_functions.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeModel with ChangeNotifier {
  HomeModel({
    required this.database,
    required this.functions,
  });

  final FirestoreDatabase database;
  final CloudFunctions functions;

  String get today {
    final now = DateTime.now();
    final f = DateFormat.MMMEd();

    return f.format(now);
  }

  Stream<User?> get userStream => database.userStream();

  Stream<List<Account?>> get accountsStream => database.accountsStream();

  Stream<List<Transaction?>> get transactionsStream {
    return database.transactionsStream(5);
  }

  Map<AccountType, List<Account?>> accountsByType(List<Account?> accounts) {
    final map = <AccountType, List<Account?>>{};

    for (final account in accounts) {
      (map[account!.type] ??= []).add(account);
    }

    return map;
  }

  Future<void> transactionsRefresh(BuildContext context, User user) async {
    try {
      final response = await functions.transactionsRefresh(user);

      if (response.statusCode == 404) {
        showAdaptiveDialog(
          context,
          title: 'Refresh Error',
          content:
              'We could not refresh the data. Please re-authenticate your account using the Plaid Link',
          defaultActionText: 'OK',
        );
      }
    } on http.Response catch (response) {
      if (response.statusCode == 404) {
        logger.e(response);

        showAdaptiveDialog(
          context,
          title: 'An Error Occurred',
          content: 'An Error Occurred',
          defaultActionText: 'OK',
        );
      }
      throw showAdaptiveDialog(
        context,
        title: 'An Error Occurred',
        content: 'An Error Occurred',
        defaultActionText: 'OK',
      );
    } on SocketException catch (e) {
      logger.e('SocketException: $e');

      showAdaptiveDialog(
        context,
        title: 'An Error Occurred',
        content: 'An Error Occurred',
        defaultActionText: 'OK',
      );
    } catch (e) {
      logger.e(e);

      showAdaptiveDialog(
        context,
        title: 'An Error Occurred',
        content: 'An Error Occurred',
        defaultActionText: 'OK',
      );
    }
  }
}
