import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final allTransactionsModelProvider =
    Provider.autoDispose.family<AllTransactionsModel, List<Transaction?>>(
  (ref, transactions) {
    final auth = ref.watch(authProvider);
    final database = ref.watch(databaseProvider(auth.currentUser!.uid));

    return AllTransactionsModel(database: database, transactions: transactions);
  },
);

class AllTransactionsModel {
  AllTransactionsModel({
    required this.database,
    required this.transactions,
  });

  final FirestoreDatabase database;
  final List<Transaction?> transactions;

  Stream<List<Transaction?>> get transactionsStream {
    return database.transactionsStream();
  }

  Map<String, List<Transaction?>> get transactionsByYear {
    // final now = DateTime.now();

    final map = <String, List<Transaction?>>{};

    for (final transaction in transactions) {
      final f = DateFormat.yMMMM();
      final yMMMM = f.format(transaction!.date);

      map.putIfAbsent(yMMMM, () => []).add(transaction);
    }

    // final diff = now.difference(DateTime.now());
    // print('took ${diff.inMilliseconds} milliseconds');

    return map;
  }
}
