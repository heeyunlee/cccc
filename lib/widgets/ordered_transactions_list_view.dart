import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/view_models/all_transactions_model.dart';
import 'package:cccc/widgets/transaction_list_tile.dart';
import 'package:flutter/material.dart';

class OrderedTransactionsListView extends StatefulWidget {
  const OrderedTransactionsListView({
    Key? key,
    required this.model,
  }) : super(key: key);

  final AllTransactionsModel model;

  @override
  State<OrderedTransactionsListView> createState() =>
      _OrderedTransactionsListViewState();
}

class _OrderedTransactionsListViewState
    extends State<OrderedTransactionsListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: widget.model.transactionsByYear.values.length,
      itemBuilder: (context, index) {
        final yMMMM = widget.model.transactionsByYear.keys.toList()[index];
        final transactions =
            widget.model.transactionsByYear.values.toList()[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 40, 32, 8),
              child: Text(yMMMM, style: TextStyles.h6W900),
            ),
            ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider(
                  indent: 16,
                  endIndent: 16,
                  color: Colors.white12,
                  height: 1,
                );
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: transactions.length,
              itemBuilder: (context, index) => TransactionListTile(
                transaction: transactions[index]!,
              ),
            ),
          ],
        );
      },
    );
    // return Column(
    //   children: [
    //     ...widget.model.transactionsByYear.entries.map(
    //       (entry) {
    //         final yMMMM = entry.key;
    //         final newTransactions = entry.value;

    //         return Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.fromLTRB(32, 40, 32, 8),
    //               child: Text(yMMMM, style: TextStyles.h6W900),
    //             ),
    //             ListView.separated(
    //               separatorBuilder: (context, index) {
    //                 return const Divider(
    //                   indent: 16,
    //                   endIndent: 16,
    //                   color: Colors.white12,
    //                   height: 1,
    //                 );
    //               },
    //               shrinkWrap: true,
    //               physics: const NeverScrollableScrollPhysics(),
    //               padding: EdgeInsets.zero,
    //               itemCount: newTransactions.length,
    //               itemBuilder: (context, index) => TransactionListTile(
    //                 transaction: newTransactions[index]!,
    //               ),
    //             ),
    //           ],
    //         );
    //       },
    //     ).toList(),
    //   ],
    // );
  }
}
