import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/theme/text_styles.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class AccountsListTile extends StatelessWidget {
  const AccountsListTile({
    Key? key,
    required this.account,
  }) : super(key: key);

  final Account account;

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat(',###', 'en_US');
    final current = f.format(account.balance.current);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueGrey,
        child: Text(
          account.name[0],
          style: TextStyles.body2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      onTap: () {},
      title: Text(
        account.name,
        style: TextStyles.body2,
      ),
      subtitle: Text(
        '${account.subtype}',
        style: TextStyles.captionGrey,
      ),
      // subtitle: Padding(
      //   padding: const EdgeInsets.symmetric(
      //     vertical: 8,
      //   ),
      //   child: Text(
      //     '\$ $current',
      //     style: TextStyles.h6W900,
      //   ),
      // ),
      trailing: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Text(
          '\$ $current',
          style: TextStyles.h6W900,
        ),
      ),
    );
  }
}
