import 'package:cccc/models/enum/scan_receipt_state.dart';
import 'package:cccc/theme/custom_button_theme.dart';
import 'package:cccc/view_models/scan_receipt_bottom_sheet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReceiptImagePreviewWidget extends ConsumerWidget {
  const ReceiptImagePreviewWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final model = ref.watch(scanReceiptBottomSheetModelProvider);

    return Column(
      children: [
        const SizedBox(height: 8),
        AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => model.toggleState(ScanReceiptState.start),
          ),
          centerTitle: true,
          title: const Text('Choose Image'),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.file(
            model.image!,
            height: size.height / 2,
          ),
        ),
        const Spacer(),
        const Text('Use this Image?'),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: (size.width - 64) / 2,
              height: 48,
              child: OutlinedButton(
                onPressed: () => model.toggleState(ScanReceiptState.start),
                style: CustomButtonTheme.outline1,
                child: const Text('Choose Other'),
              ),
            ),
            const SizedBox(width: 24),
            SizedBox(
              height: 48,
              width: (size.width - 64) / 2,
              child: ElevatedButton(
                style: CustomButtonTheme.elevated1,
                onPressed: () => model.getTransactionitems(context),
                child: const Text('Yes'),
              ),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
      ],
    );
  }
}
