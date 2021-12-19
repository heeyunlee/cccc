import 'package:cccc/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cccc/model/plaid/transaction.dart';

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
      leading: const SizedBox(
        width: 32,
        height: 64,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '🍔',
            style: TextStyles.body1,
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
            transaction.category.toString(),
            maxLines: 1,
            style: TextStyles.overlineGrey,
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('EEE, M/d/y').format(transaction.date),
            style: TextStyles.captionBoldWhite12,
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
