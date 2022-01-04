import 'dart:io';
import 'package:cccc/models/enum/account_type.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/models/user.dart';
import 'package:cccc/services/cloud_functions.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

final homeScreenModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final auth = ref.watch(authProvider);
    final uid = auth.currentUser!.uid;
    final database = ref.watch(databaseProvider(uid));
    final functions = ref.watch(cloudFunctionsProvider);

    return HomeScreenModel(database: database, functions: functions);
  },
);

class HomeScreenModel with ChangeNotifier {
  HomeScreenModel({
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
    return database.transactionsStream();
  }

  Map<AccountType, List<Account?>> accountsByType(List<Account?> accounts) {
    final map = <AccountType, List<Account?>>{};

    for (final account in accounts) {
      (map[account!.type] ??= []).add(account);
    }

    return map;
  }

  Future<void> fetchData(BuildContext context, User user) async {
    try {
      functions.getTransactions(context, user);
    } on http.Response catch (response) {
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
}
