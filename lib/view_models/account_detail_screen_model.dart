import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final accountDetailScreenModelProvider = ChangeNotifierProvider.family
    .autoDispose<AccountDetailScreenModel, Account>(
  (ref, account) {
    final auth = ref.watch(authProvider);
    final database = ref.watch(databaseProvider(auth.currentUser!.uid));

    return AccountDetailScreenModel(account: account, database: database);
  },
);

class AccountDetailScreenModel with ChangeNotifier {
  AccountDetailScreenModel({
    required this.account,
    required this.database,
  });

  final Account account;
  final FirestoreDatabase database;

  String get name => account.name;

  String get mask => '**${account.mask}';

  String get currentAmount {
    final f = NumberFormat.simpleCurrency(
      name: account.balance.isoCurrencyCode,
      decimalDigits: 2,
    );
    final amount = f.format(account.balance.current);

    return amount;
  }

  Stream<List<Transaction?>> get transactionsStream {
    return database.transactionsForAccountStream(account.accountId);
  }
}
