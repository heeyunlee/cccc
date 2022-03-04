import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cccc/models/enum/scan_receipt_state.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/providers.dart' show scanReceiptBottomSheetModelProvider;
import 'package:cccc/styles/styles.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';
import 'package:cccc/widgets/transaction_list_tile.dart';

class MatchTransactionWithItemsWidget extends ConsumerWidget {
  const MatchTransactionWithItemsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = MediaQuery.of(context).padding;
    final model = ref.watch(scanReceiptBottomSheetModelProvider);

    return CustomStreamBuilder<List<Transaction?>>(
      stream: model.transactionsStream!,
      errorBuilder: (context, error) => Container(),
      loadingWidget: const Center(
        child: CircularProgressIndicator(),
      ),
      builder: (context, transactions) {
        if (transactions != null && transactions.isNotEmpty) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Text(
                    'Choose the transaction that matches the scanned receipt',
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index]!;

                      return TransactionListTile(
                        color: Theme.of(context).primaryColor.withOpacity(0.12),
                        transaction: transaction,
                        enableOnTap: true,
                        onTap: () => ref
                            .read(scanReceiptBottomSheetModelProvider)
                            .selectTransaction(context,
                                transaction: transaction),
                      );
                    },
                  ),
                ),
                SizedBox(height: padding.bottom),
              ],
            ),
          );
        } else {
          return Column(
            children: [
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Text(
                      'We could not find the matching data. Please scan a different receipt',
                    ),
                  ),
                ),
              ),
              OutlinedButton(
                style: ButtonStyles.outline(context, height: 48),
                onPressed: () => ref
                    .read(scanReceiptBottomSheetModelProvider)
                    .toggleState(ScanReceiptState.start),
                child: const Text('Scan Different Receipt'),
              ),
              const SizedBox(height: 16),
            ],
          );
        }
      },
    );
  }
}
