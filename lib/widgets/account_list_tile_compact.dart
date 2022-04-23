import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/styles/styles.dart';
import 'package:cccc/views/details/account_detail.dart';
import 'package:flutter/material.dart';

class AccountListTileCompact extends StatelessWidget {
  const AccountListTileCompact({
    Key? key,
    required this.account,
    this.institution,
  }) : super(key: key);

  final Account account;
  final Institution? institution;

  String get mask => '**' + (account.mask ?? '0000');

  String get name => account.officialName ?? account.name;

  String get currentAccount =>
      Formatter.currency(account.balance.current, 'en_US');

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      onTap: () => AccountDetail.show(
        context,
        account: account,
        institution: institution,
      ),
      title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(mask, style: TextStyles.overlineGrey),
      trailing: Text(currentAccount, style: TextStyles.subtitle1BoldWhite70),
    );
  }
}
