import 'package:cccc/theme/custom_button_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScanReceiptCompletedWidget extends ConsumerWidget {
  const ScanReceiptCompletedWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Transaction updated successfully!'),
        const SizedBox(height: 24),
        const Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            height: 48,
            width: double.maxFinite,
            child: OutlinedButton(
              style: CustomButtonTheme.outline1,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Comlete!'),
            ),
          ),
        ),
      ],
    );
  }
}
