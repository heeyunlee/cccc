import 'package:cccc/models/enum/scan_receipt_state.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/view_models/scan_receipt_bottom_sheet_model.dart';
import 'package:cccc/widgets/bottom_sheet_card.dart';
import 'package:cccc/widgets/floating_outlined_button.dart';
import 'package:cccc/widgets/scan_receipt/check_receipt_image_widget.dart';
import 'package:cccc/widgets/scan_receipt/scan_receipt_completed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'choose_image_to_scan_widget.dart';
import 'match_transaction_with_items_widget.dart';
import 'check_items_widget.dart';

class ScanReceiptBottomSheet extends ConsumerStatefulWidget {
  const ScanReceiptBottomSheet({
    Key? key,
    this.transaction,
  }) : super(key: key);

  final Transaction? transaction;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScanReceiptBottomSheetState();
}

class _ScanReceiptBottomSheetState
    extends ConsumerState<ScanReceiptBottomSheet> {
  @override
  Widget build(BuildContext context) {
    logger.d('[ScanReceiptsBottomSheet] building...');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _getHeight(),
      alignment: Alignment.topCenter,
      child: BottomSheetCard(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildChild(),
            ),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  double _getHeight() {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final model = ref.watch(scanReceiptBottomSheetModelProvider);

    switch (model.state) {
      case ScanReceiptState.start:
        return padding.bottom + 192;
      case ScanReceiptState.checkImage:
        return size.height * 0.8;
      case ScanReceiptState.checkTexts:
        return size.height * 0.85;
      case ScanReceiptState.checkTransaction:
        return size.height * 0.85;
      case ScanReceiptState.loading:
        return padding.bottom + 192;
      case ScanReceiptState.error:
        return padding.bottom + 268;
      case ScanReceiptState.completed:
        return 270;
    }
  }

  Widget _buildChild() {
    final model = ref.watch(scanReceiptBottomSheetModelProvider);

    switch (model.state) {
      case ScanReceiptState.start:
        return const ChooseImageToScanWidget();
      case ScanReceiptState.checkImage:
        return const CheckReceiptImageWidget();
      case ScanReceiptState.checkTexts:
        return CheckItemsWidget(transaction: widget.transaction);
      case ScanReceiptState.checkTransaction:
        return const MatchTransactionWithItemsWidget();
      case ScanReceiptState.loading:
        return const Center(child: CircularProgressIndicator.adaptive());
      case ScanReceiptState.error:
        return ChooseImageToScanWidget(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.error_outline, color: Colors.red),
              SizedBox(width: 8),
              Text('Got Error!', style: TextStyles.body1Bold),
            ],
          ),
          subtitle:
              'We could not fetch receipt items from the image. Please try again',
        );
      case ScanReceiptState.completed:
        return const ScanReceiptCompletedWidget();
    }
  }

  Widget _buildButton() {
    final model = ref.watch(scanReceiptBottomSheetModelProvider);

    switch (model.state) {
      case ScanReceiptState.start:
        return const SizedBox.shrink();
      case ScanReceiptState.checkImage:
        return FloatingOutlinedButton(
          buttonName: 'Continue',
          onPressed: () => model.getTransactionitems(context),
        );
      case ScanReceiptState.checkTexts:
        return FloatingOutlinedButton(
          buttonName: 'Continue',
          onPressed: () => model.showMatchingTransaction(context,
              transaction: widget.transaction),
        );
      case ScanReceiptState.checkTransaction:
        return const SizedBox.shrink();
      case ScanReceiptState.loading:
        return const SizedBox.shrink();
      case ScanReceiptState.error:
        return const SizedBox.shrink();
      case ScanReceiptState.completed:
        return const SizedBox.shrink();
    }
  }
}
