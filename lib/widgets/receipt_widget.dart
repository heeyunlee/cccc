import 'package:cccc/models/enum/transaction_item_type.dart';
import 'package:cccc/models/transaction_item.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptWidget extends StatelessWidget {
  const ReceiptWidget({
    Key? key,
    required this.transactionItems,
    this.date,
    this.name,
    this.color,
    this.enableEdit = false,
  }) : super(key: key);

  final List<TransactionItem> transactionItems;
  final DateTime? date;
  final String? name;
  final Color? color;
  final bool? enableEdit;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      color: color,
      margin: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          if (name != null) Text(name!),
          if (name != null) const SizedBox(height: 16),
          if (date != null)
            Text(DateFormat.yMMMd().format(date!), style: TextStyles.caption),
          if (date != null) const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactionItems.length,
            itemBuilder: (context, index) {
              final item = transactionItems[index];

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width - 180,
                          child: Text(
                            _itemName(item),
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: _itemTextStyle(item),
                          ),
                        ),
                        Text(
                          _itemAmount(item),
                          style: _itemTextStyle(item),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
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
        return TextStyles.body1Bold;
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
}
