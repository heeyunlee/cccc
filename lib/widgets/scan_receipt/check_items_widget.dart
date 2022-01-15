import 'package:cccc/models/enum/scan_receipt_state.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/view_models/scan_receipt_bottom_sheet_model.dart';
import 'package:cccc/widgets/receipt_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckItemsWidget extends ConsumerWidget {
  const CheckItemsWidget({Key? key, this.transaction}) : super(key: key);

  final Transaction? transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final model = ref.watch(scanReceiptBottomSheetModelProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Scaffold(
        backgroundColor: theme.bottomSheetTheme.backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => ref
                .read(scanReceiptBottomSheetModelProvider)
                .toggleState(ScanReceiptState.start),
          ),
          centerTitle: true,
          title: const Text('Review the retrieved data'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Are transaction items correct? If not, please choose different image to scan',
                ),
              ),
              const SizedBox(height: 24),
              ReceiptWidget(
                date: model.receiptResponse!.date,
                name: model.receiptResponse!.name,
                color: theme.primaryColor.withOpacity(0.24),
                transactionItems: model.receiptResponse!.transactionItems!,
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
