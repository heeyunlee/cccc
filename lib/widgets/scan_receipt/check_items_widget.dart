import 'package:cccc/models/enum/scan_receipt_state.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/theme/custom_button_theme.dart';
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
    final media = MediaQuery.of(context);
    final model = ref.watch(scanReceiptBottomSheetModelProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => ref
                .read(scanReceiptBottomSheetModelProvider)
                .toggleState(ScanReceiptState.start),
          ),
          centerTitle: true,
          title: const Text('Review the retrieved data'),
        ),
        const Spacer(),
        ReceiptWidget(
          color: theme.primaryColor.withOpacity(0.24),
          transactionItems: model.transactionItems!,
        ),
        const Spacer(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Are transaction items correct? If not, please choose different image to scan',
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 48,
              width: (media.size.width - 64) / 2,
              child: OutlinedButton(
                style: CustomButtonTheme.outline1,
                onPressed: () => ref
                    .read(scanReceiptBottomSheetModelProvider)
                    .toggleState(ScanReceiptState.start),
                child: const Text('Choose Other'),
              ),
            ),
            const SizedBox(width: 24),
            SizedBox(
              height: 48,
              width: (media.size.width - 64) / 2,
              child: ElevatedButton(
                style: CustomButtonTheme.elevated1,
                onPressed: () => ref
                    .read(scanReceiptBottomSheetModelProvider)
                    .showMatchingTransaction(context, transaction: transaction),
                child: const Text('Next'),
              ),
            ),
          ],
        ),
        SizedBox(height: media.padding.bottom + 16),
      ],
    );
  }
}
