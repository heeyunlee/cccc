import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cccc/models/enum/account_subtype.dart';
import 'package:cccc/models/enum/account_type.dart';
import 'package:cccc/extensions/datetime_extension.dart';

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

  String get name => account.officialName ?? account.name;

  String get title => account.subtype?.title ?? account.type.str;

  String get mask =>
      '**${account.mask} • ${account.subtype?.title ?? account.type.str}';

  String get currentAmount {
    final f = NumberFormat.simpleCurrency(
      name: account.balance.isoCurrencyCode,
      decimalDigits: 2,
    );
    final amount = f.format(account.balance.current);

    return amount;
  }

  Stream<List<Transaction?>> get transactionsStream {
    return database.accountTransactionsLimitStream(account.accountId);
  }

  Stream<Institution?> get institutionStream {
    return database.institutionStream(account.institutionId);
  }

  String? get lastSyncedDate {
    final accountLastSyncedTime = account.accountLastSyncedTime;

    if (accountLastSyncedTime != null) {
      return accountLastSyncedTime.timeago;
    }
  }
}
