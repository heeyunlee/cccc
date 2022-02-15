import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allTransactionsModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final auth = ref.watch(authProvider);
    final database = ref.watch(databaseProvider(auth.currentUser!.uid));

    return AllTransactionsModel(database: database);
  },
);

class AllTransactionsModel with ChangeNotifier {
  AllTransactionsModel({
    required this.database,
  });

  final FirestoreDatabase database;

  bool get isLoading => _isLoading;
  List<Transaction> get transactions => _transactions;

  bool _isLoading = false;
  DocumentSnapshot<Transaction>? _lastDocSnapshot;
  final List<Transaction> _transactions = [];

  void _toggleIsLoading() {
    _isLoading = !_isLoading;

    notifyListeners();
  }

  Future<void> getTransactions() async {
    final queryResponse = await database.transactionsQuery();

    transactions.addAll(queryResponse.list);
    _lastDocSnapshot = queryResponse.lastDocSnapshot;

    notifyListeners();
  }

  bool onScrollNotification(BuildContext context, ScrollNotification n) {
    final maxScroll = n.metrics.maxScrollExtent;
    final currentScroll = n.metrics.pixels;
    final delta = MediaQuery.of(context).size.height * 0.25;

    if (maxScroll - currentScroll <= delta) {
      if (_lastDocSnapshot != null) {
        _fetchTransactions(context);
      }
      return true;
    } else {
      return false;
    }
  }

  Future<void> _fetchTransactions(BuildContext context) async {
    try {
      if (!_isLoading) {
        _toggleIsLoading();

        final queryResponse = await database.transactionsQuery(
          startAfterDocument: _lastDocSnapshot!,
        );
        logger.d('transaction query result: ${queryResponse.lastDocSnapshot}');

        _isLoading = false;
        _lastDocSnapshot = queryResponse.lastDocSnapshot;
        transactions.addAll(queryResponse.list);
        notifyListeners();
      }
    } catch (e) {
      logger.e(e);

      _toggleIsLoading();

      await showAdaptiveDialog(
        context,
        title: 'title',
        content: e.toString(),
        defaultActionText: 'OK',
      );
    }
  }

  // Map<String, List<Transaction?>> get transactionsByYear {
  //   // final now = DateTime.now();

  //   final map = <String, List<Transaction?>>{};

  //   for (final transaction in _transactions) {
  //     final f = DateFormat.yMMMM();
  //     final yMMMM = f.format(transaction!.date);

  //     map.putIfAbsent(yMMMM, () => []).add(transaction);
  //   }

  //   // final diff = now.difference(DateTime.now());
  //   // print('took ${diff.inMilliseconds} milliseconds');

  //   return map;
  // }
}
