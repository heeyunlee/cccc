import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cccc/enum/scan_receipt_state.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/providers.dart' show scanReceiptBottomSheetModelProvider;
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/styles/theme_colors.dart';
import 'package:cccc/widgets/bottom_sheet_card.dart';

import 'check_items_widget.dart';
import 'choose_image_to_scan_widget.dart';
import 'match_transaction_with_items_widget.dart';

class ScanReceiptBottomSheet extends ConsumerStatefulWidget {
  const ScanReceiptBottomSheet({
    super.key,
    this.transaction,
  });

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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: _buildAppBarButton(),
            centerTitle: true,
            title: _buildAppBarTitleString(),
          ),
          body: _buildChild(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _buildFAB(),
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
      case ScanReceiptState.editItems:
        return size.height * 0.9;
      case ScanReceiptState.chooseTransaction:
        return size.height * 0.9;
      case ScanReceiptState.loading:
        return padding.bottom + 192;
      case ScanReceiptState.error:
        return padding.bottom + 268;
      case ScanReceiptState.completed:
        return 270;
    }
  }

  Widget? _buildAppBarButton() {
    final model = ref.watch(scanReceiptBottomSheetModelProvider);

    switch (model.state) {
      case ScanReceiptState.start:
      case ScanReceiptState.error:
        return IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        );
      case ScanReceiptState.editItems:
      case ScanReceiptState.chooseTransaction:
        return IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => ref
              .read(scanReceiptBottomSheetModelProvider)
              .toggleState(ScanReceiptState.start),
        );
      case ScanReceiptState.loading:
      case ScanReceiptState.completed:
        return const IconButton(
          icon: Icon(Icons.arrow_back_ios, color: ThemeColors.grey900),
          onPressed: null,
        );
    }
  }

  Widget _buildAppBarTitleString() {
    final model = ref.watch(scanReceiptBottomSheetModelProvider);

    switch (model.state) {
      case ScanReceiptState.start:
      case ScanReceiptState.error:
        return const Text('Choose Source');
      case ScanReceiptState.editItems:
        return const Text('Edit Receipt Items');
      case ScanReceiptState.chooseTransaction:
        return const Text('Choose Transaction');
      case ScanReceiptState.loading:
      case ScanReceiptState.completed:
        return const Text('');
    }
  }

  Widget _buildChild() {
    final model = ref.watch(scanReceiptBottomSheetModelProvider);

    switch (model.state) {
      case ScanReceiptState.start:
        return const ChooseImageToScanWidget();
      case ScanReceiptState.editItems:
        return CheckItemsWidget(transaction: widget.transaction);
      case ScanReceiptState.chooseTransaction:
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text('Transaction updated successfully!'),
            SizedBox(height: 24),
            Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
            SizedBox(height: 24, width: double.maxFinite),
          ],
        );
    }
  }

  Widget _buildFAB() {
    final model = ref.watch(scanReceiptBottomSheetModelProvider);

    switch (model.state) {
      case ScanReceiptState.start:
        return const SizedBox.shrink();
      case ScanReceiptState.editItems:
        return FloatingActionButton.extended(
          onPressed: () => ref
              .read(scanReceiptBottomSheetModelProvider)
              .showMatchingTransaction(context,
                  transaction: widget.transaction),
          label: const Text('Continue'),
        );
      case ScanReceiptState.chooseTransaction:
        return const SizedBox.shrink();
      case ScanReceiptState.loading:
        return const SizedBox.shrink();
      case ScanReceiptState.error:
        return const SizedBox.shrink();
      case ScanReceiptState.completed:
        return FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).pop(true),
          label: const Text('COMPLETE!'),
        );
    }
  }
}
