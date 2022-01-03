import 'package:cccc/models/enum/account_type.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/widgets/accounts_list_tile.dart';
import 'package:flutter/material.dart';

class AccountsExpansionTile extends StatelessWidget {
  const AccountsExpansionTile({
    Key? key,
    required this.accountType,
    required this.accounts,
  }) : super(key: key);

  final AccountType accountType;
  final List<Account?> accounts;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(accountType.icon),
      initiallyExpanded: true,
      collapsedIconColor: Colors.white,
      iconColor: Colors.white,
      collapsedTextColor: Colors.white,
      textColor: Colors.white,
      title: Text(accountType.str),
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: accounts.length,
          itemBuilder: (context, index) {
            final account = accounts[index]!;

            return AccountsListTile(account: account);
          },
        ),
      ],
    );
  }
}
