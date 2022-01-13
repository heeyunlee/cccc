import 'package:cccc/models/enum/scan_receipt_state.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/theme/custom_button_theme.dart';
import 'package:cccc/view_models/scan_receipt_bottom_sheet_model.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';
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
    final model = ref.watch(scanReceiptBottomSheetModelProvider);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        CustomStreamBuilder<List<Transaction?>>(
          stream: model.transactionsStream!,
          builder: (context, data) {
            logger.d('Got matching data: ${data.toString()}');

            if (data.isNotEmpty) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 64),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final transaction = data[index]!;

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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      height: 48,
                      width: double.maxFinite,
                      child: OutlinedButton(
                        onPressed: () => ref
                            .read(scanReceiptBottomSheetModelProvider)
                            .toggleState(ScanReceiptState.start),
                        style: CustomButtonTheme.outline1,
                        child: const Text('Scan different receipt'),
                      ),
                    ),
                  ),
                  SizedBox(height: padding.bottom),
                ],
              );
            }
          },
        ),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.grey[850]!,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => ref
                  .read(scanReceiptBottomSheetModelProvider)
                  .toggleState(ScanReceiptState.start),
            ),
            centerTitle: true,
            title: const Text('Match'),
          ),
        ),
      ],
    );
  }
}
