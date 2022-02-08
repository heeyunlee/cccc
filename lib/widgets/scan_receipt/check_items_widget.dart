import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/view_models/scan_receipt_bottom_sheet_model.dart';
import 'package:cccc/widgets/scan_receipt/transaction_item_listtile.dart';
import 'package:cccc/widgets/scan_receipt/transaction_subtotal_item_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckItemsWidget extends ConsumerWidget {
  const CheckItemsWidget({Key? key, this.transaction}) : super(key: key);

  final Transaction? transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(scanReceiptBottomSheetModelProvider);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Are transaction items correct? You can edit the item description and price',
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Color.alphaBlend(
              Theme.of(context).primaryColor.withOpacity(0.12),
              Colors.grey[900]!,
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: model.transactionItems!.length,
                  itemBuilder: (context, index) {
                    final transactionItem = model.transactionItems![index];

                    return TransactionItemListTile(
                      transactionItem: transactionItem,
                      index: index,
                    );
                  },
                ),
                const TransactionSubtotalItemListTile(),
                const SizedBox(height: 24),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
