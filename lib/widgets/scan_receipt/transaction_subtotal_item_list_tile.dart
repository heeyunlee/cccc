import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:cccc/providers.dart' show scanReceiptBottomSheetModelProvider;
import 'package:cccc/styles/text_styles.dart';

class TransactionSubtotalItemListTile extends ConsumerWidget {
  const TransactionSubtotalItemListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(scanReceiptBottomSheetModelProvider);

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(color: Colors.white12, endIndent: 8, indent: 8),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.body1Bold,
              ),
              Text(
                NumberFormat.simpleCurrency(
                  name: model.subtotalItem!.isoCurrencyCode,
                  decimalDigits: 2,
                ).format(model.subtotalItem!.amount),
                style: TextStyles.body1Bold,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
