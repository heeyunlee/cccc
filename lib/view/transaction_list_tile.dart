import 'package:cccc/constants/constants.dart';
import 'package:cccc/theme/text_styles.dart';
import 'package:flutter/material.dart';

import 'package:cccc/model/plaid/transaction.dart';
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
          ),
        ),
      ),
      title: Text(
        transaction.name,
        style: TextStyles.body1,
        maxLines: 1,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.category?[0] ?? 'Uncategorized',
            style: TextStyles.caption,
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('M/d/y').format(transaction.date),
            style: TextStyles.captionGreyBold,
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
            style: TextStyles.body2,
          ),
        ),
      ),
      onTap: () {},
    );
  }
}
