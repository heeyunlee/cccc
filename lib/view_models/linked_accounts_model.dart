import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/services/database.dart';
import 'package:flutter/material.dart';

class LinkedAccountsModel with ChangeNotifier {
  LinkedAccountsModel({
    required this.accounts,
    required this.database,
  });

  final List<Account?> accounts;
  final Database database;

  Stream<List<Account?>> get accountsStream => database.accountsStream();

  Map<String, List<Account?>> get accountsByInstitution {
    final map = <String, List<Account?>>{};

    for (final account in accounts) {
      (map[account!.institutionId] ??= []).add(account);
    }

    return map;
  }

  Stream<Institution?> institutionStream(String institutionId) {
    return database.institutionStream(institutionId);
  }
}
