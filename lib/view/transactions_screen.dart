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
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            pinned: false,
            stretch: true,
            title: Text('Transactions'),
          ),
          SliverToBoxAdapter(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 48,
              ),
              itemCount: transactions.length,
              itemBuilder: (context, index) => TransactionListTile(
                transaction: transactions[index]!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
