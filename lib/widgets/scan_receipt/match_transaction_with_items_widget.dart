import 'package:cccc/models/enum/scan_receipt_state.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/view_models/scan_receipt_bottom_sheet_model.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';
import 'package:cccc/widgets/floating_outlined_button.dart';
import 'package:cccc/widgets/transaction_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchTransactionWithItemsWidget extends ConsumerWidget {
  const MatchTransactionWithItemsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = MediaQuery.of(context).padding;
    final theme = Theme.of(context);
    final model = ref.watch(scanReceiptBottomSheetModelProvider);

    return Scaffold(
      backgroundColor: theme.bottomSheetTheme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => ref
              .read(scanReceiptBottomSheetModelProvider)
              .toggleState(ScanReceiptState.start),
        ),
        centerTitle: true,
        title: const Text('Match'),
      ),
      body: CustomStreamBuilder<List<Transaction?>>(
        stream: model.transactionsStream!,
        // TODO: add errorWidget and loadingWidget
        errorWidget: Container(),
        loadingWidget: Container(),
        builder: (context, transactions) {
          if (transactions != null && transactions.isNotEmpty) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 64),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Text(
                        'We could not find the matching data. Please scan a different receipt',
                      ),
                    ),
                  ),
                ),
                FloatingOutlinedButton(
                  buttonName: 'Scan Different Receipt',
                  onPressed: () => ref
                      .read(scanReceiptBottomSheetModelProvider)
                      .toggleState(ScanReceiptState.start),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
