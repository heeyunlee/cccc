import 'package:cccc/model/plaid/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsList extends StateNotifier<List<Transaction>> {
  TransactionsList([List<Transaction>? transactions]) : super(const []);

  void add(List<Transaction> transactions) {
    state = List.from(state)..addAll(transactions);
  }
}
