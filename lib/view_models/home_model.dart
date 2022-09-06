import 'package:cccc/enum/account_type.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/models/user.dart';
import 'package:cccc/services/cloud_functions.dart';
import 'package:cccc/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeModel with ChangeNotifier {
  HomeModel({
    required this.database,
    required this.functions,
  });

  final Database database;
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

  Future<int> transactionsRefresh(User user) async {
    try {
      final response = await functions.transactionsRefresh(user);

      return response.statusCode;
    } catch (e) {
      return 404;
    }
  }
}
