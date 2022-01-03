import 'package:cccc/constants/constants.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/theme/text_styles.dart';
import 'package:cccc/view/transaction_detail_screen.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class TransactionListTile extends StatelessWidget {
  const TransactionListTile({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
            Constants.categoryIdToEmoji[transaction.categoryId],
            size: 20,
            color: transaction.pending ? Colors.white38 : Colors.white,
          ),
        ),
      ),
      title: Text(
        transaction.name,
        style: transaction.pending
            ? TextStyles.body1White38Bold
            : TextStyles.body1Bold,
        maxLines: 1,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.category?[0] ?? 'Uncategorized',
            style: transaction.pending
                ? TextStyles.captionWhite38
                : TextStyles.caption,
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('M/d/y').format(transaction.date),
            style: transaction.pending
                ? TextStyles.captionWhite38Bold
                : TextStyles.captionGreyBold,
            maxLines: 1,
          ),
        ],
      ),
      trailing: SizedBox(
        width: 80,
        height: 64,
        child: Center(
          child: Text(
            '\$ ${transaction.amount.toString()}',
            style: transaction.pending
                ? TextStyles.body2White38
                : TextStyles.body2,
          ),
        ),
      ),
      onTap: () => TransactionDetailScreen.show(context, transaction),
    );
  }
}
