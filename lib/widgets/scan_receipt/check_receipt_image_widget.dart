import 'package:cccc/models/enum/scan_receipt_state.dart';
import 'package:cccc/view_models/scan_receipt_bottom_sheet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckReceiptImageWidget extends ConsumerWidget {
  const CheckReceiptImageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final model = ref.watch(scanReceiptBottomSheetModelProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Scaffold(
        backgroundColor: theme.bottomSheetTheme.backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => model.toggleState(ScanReceiptState.start),
          ),
          centerTitle: true,
          title: const Text('Choose Image'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(children: const []),
            const SizedBox(height: 8),
            Card(
              borderOnForeground: true,
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 32),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.file(
                model.image!,
                height: size.height / 2,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            const Text('Use this Image?'),
          ],
        ),
      ),
    );
  }
}
