import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final linkedAccountsModelProvider = ChangeNotifierProvider.autoDispose
    .family<LinkedAccountsModel, List<Account?>>(
  (ref, accounts) {
    final database = ref.watch(databaseProvider);

    return LinkedAccountsModel(accounts: accounts, database: database);
  },
);

class LinkedAccountsModel with ChangeNotifier {
  LinkedAccountsModel({
    required this.accounts,
    required this.database,
  });

  final List<Account?> accounts;
  final FirestoreDatabase database;

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
