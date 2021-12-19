import 'package:cccc/view/transaction_list_tile.dart';
import 'package:flutter/material.dart';

import 'package:cccc/model/plaid/transaction.dart';
import 'package:cccc/routes/route_names.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  final List<Transaction?> transactions;

  static void show(
    BuildContext context, {
    required List<Transaction?> transactions,
  }) {
    Navigator.of(context).pushNamed(
      RouteNames.transactions,
      arguments: transactions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(
          top: 80,
          left: 16,
          right: 16,
          bottom: 48,
        ),
        itemCount: transactions.length,
        itemBuilder: (context, index) => TransactionListTile(
          transaction: transactions[index]!,
        ),
      ),
    );
  }
}
