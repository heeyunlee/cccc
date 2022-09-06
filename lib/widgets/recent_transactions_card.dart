import 'package:cccc/extensions/context_extension.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/routes/router.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'custom_stream_builder.dart';
import 'transaction_list_tile.dart';

class RecentTransactionsCard extends ConsumerWidget {
  const RecentTransactionsCard({
    super.key,
    required this.transactionsStream,
    this.titleTextStyle = TextStyles.h6,
    this.bottomPaddingHeight = 0,
  });

  final Stream<List<Transaction?>> transactionsStream;
  final TextStyle titleTextStyle;
  final double bottomPaddingHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 16, 0),
          child: Row(
            children: [
              Text('Transactions', style: titleTextStyle),
              const Spacer(),
              Button.text(
                onPressed: () => context.pushRoute(AppRoutes.transactions),
                child: Row(
                  children: const [
                    Text('View More', style: TextStyles.button2),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16)
                  ],
                ),
              ),
            ],
          ),
        ),
        CustomStreamBuilder<List<Transaction?>>(
          errorBuilder: (context, error) => SizedBox(
            height: size.height / 2,
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'An Error Occurred. Error code: ${error.toString()}',
                ),
              ),
            ),
          ),
          loadingWidget: SizedBox(
            height: size.height / 2,
            width: double.maxFinite,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          stream: transactionsStream,
          builder: (context, transactions) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return TransactionListTile(
                          transaction: transactions[index]!,
                        );
                      },
                    ),
            );
          },
        ),
        SizedBox(height: bottomPaddingHeight),
      ],
    );
  }
}
