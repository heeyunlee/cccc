import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/styles/button_styles.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/view_models/home_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'custom_stream_builder.dart';
import 'transaction_list_tile.dart';
import '../views/all_transactions.dart';

class RecentTransactionsCard extends ConsumerWidget {
  const RecentTransactionsCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  final HomeScreenModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomStreamBuilder<List<Transaction?>>(
      errorBuilder: (context, error) => SizedBox(
        height: 200,
        width: double.maxFinite,
        child: Text('An Error Occurred. Error code: ${error.toString()}'),
      ),
      loadingWidget: const SizedBox(
        height: 200,
        width: double.maxFinite,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      stream: model.transactionsStream,
      builder: (context, transactions) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 4,
              ),
              child: Row(
                children: [
                  const Text('Transactions', style: TextStyles.h6),
                  const Spacer(),
                  TextButton(
                    onPressed: () => AllTransactions.show(
                      context,
                      transactions: transactions ?? [],
                    ),
                    style: ButtonStyles.text2,
                    child: const Text('VIEW ALL'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.white12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.zero,
                child: (transactions == null || transactions.isEmpty)
                    ? const SizedBox(
                        height: 96 * 3,
                        child: Center(
                          child: Text(
                            'No recent transactions',
                            style: TextStyles.body2,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            transactions.length > 5 ? 5 : transactions.length,
                        itemBuilder: (context, index) {
                          return TransactionListTile(
                            transaction: transactions[index]!,
                          );
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
