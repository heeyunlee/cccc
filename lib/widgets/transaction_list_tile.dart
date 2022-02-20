import 'package:cccc/constants/constants.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/styles/styles.dart';
import 'package:cccc/views/transaction_detail.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class TransactionListTile extends StatelessWidget {
  const TransactionListTile({
    Key? key,
    required this.transaction,
    this.enableOnTap = true,
    this.onTap,
    this.color,
  }) : super(key: key);

  final Transaction transaction;
  final bool? enableOnTap;
  final void Function()? onTap;
  final Color? color;

  bool get isPending => transaction.pending;

  String get subtitle {
    final category = transaction.category;

    if (category == null) {
      return 'Uncategorized';
    }

    if (category.length > 1) {
      return category[1];
    } else {
      return category[0];
    }
  }

  String get title => transaction.name;

  String get thirdTitle => DateFormat('M/d/y').format(transaction.date);

  String get trailing => Formatter.amount(
        transaction.amount,
        transaction.isoCurrencyCode ?? 'USD',
      );

  TextStyle get trailingStyle {
    if (isPending) {
      return TextStyles.body2White38;
    } else if (transaction.amount > 0) {
      return TextStyles.body2;
    } else {
      return TextStyles.body2Green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: color,
      isThreeLine: true,
      minLeadingWidth: 24,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      leading: SizedBox(
        width: 32,
        height: 64,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            kCategoryIdEmojiMap[transaction.categoryId],
            size: 20,
            color: isPending ? Colors.white38 : Colors.white,
          ),
        ),
      ),
      title: Text(
        title,
        style: isPending ? TextStyles.body1White38Bold : TextStyles.body1Bold,
        maxLines: 1,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: isPending ? TextStyles.captionWhite38 : TextStyles.caption,
            maxLines: 1,
          ),
          const SizedBox(height: 4),
          Text(
            thirdTitle,
            style: isPending
                ? TextStyles.captionWhite38Bold
                : TextStyles.captionGreyBold,
            maxLines: 1,
          ),
        ],
      ),
      trailing: SizedBox(
        width: 104,
        height: 64,
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(trailing, style: trailingStyle),
        ),
      ),
      onTap: enableOnTap!
          ? onTap ?? () => TransactionDetail.show(context, transaction)
          : null,
    );
  }
}
