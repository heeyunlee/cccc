import 'package:cccc/models/enum/transaction_item_type.dart';
import 'package:cccc/models/transaction_item.dart';
import 'package:cccc/models/transaction_items.dart';
import 'package:cccc/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptWidget extends StatelessWidget {
  const ReceiptWidget({
    Key? key,
    required this.transactionItems,
    this.color,
  }) : super(key: key);

  final TransactionItems transactionItems;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactionItems.transactionItems.length,
            itemBuilder: (context, index) {
              final item = transactionItems.transactionItems[index];

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    if (item.type == TransactionItemType.subtotal)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Divider(color: Colors.white24),
                      ),
                    Row(
                      children: [
                        Text(_itemName(item), style: _itemTextStyle(item)),
                        const Spacer(),
                        Text(_itemAmount(item), style: _itemTextStyle(item)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text('Total', style: TextStyles.body1Bold),
                const Spacer(),
                Text(
                  _transactionAmount(),
                  style: TextStyles.body1Bold,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _itemName(TransactionItem item) {
    return item.name;
  }

  TextStyle _itemTextStyle(TransactionItem item) {
    switch (item.type) {
      case TransactionItemType.item:
        return TextStyles.caption;
      case TransactionItemType.subtotal:
        return TextStyles.captionBold;
      case TransactionItemType.tax:
        return TextStyles.caption;
      case TransactionItemType.tip:
        return TextStyles.caption;
      case TransactionItemType.others:
        return TextStyles.caption;
      default:
        return TextStyles.caption;
    }
  }

  String _itemAmount(TransactionItem item) {
    final f = NumberFormat.simpleCurrency(
      name: item.isoCurrencyCode,
      decimalDigits: 2,
    );
    final amount = f.format(item.amount);

    return amount;
  }

  String _transactionAmount() {
    final item = transactionItems.transactionItems[0];

    final f = NumberFormat.simpleCurrency(
      name: item.isoCurrencyCode,
      decimalDigits: 2,
    );
    final amount = f.format(item.amount);

    return amount;
  }
}
