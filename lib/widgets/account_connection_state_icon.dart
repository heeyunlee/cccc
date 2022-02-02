import 'package:cccc/models/enum/account_connection_state.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:flutter/material.dart';

class AccountConnectionStateIcon extends StatelessWidget {
  const AccountConnectionStateIcon({
    Key? key,
    required this.account,
    this.size = 16,
  }) : super(key: key);

  final Account? account;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (account == null) {
      return Icon(
        Icons.do_not_disturb,
        color: Colors.grey,
        size: size,
      );
    }

    switch (account!.accountConnectionState) {
      case AccountConnectionState.healthy:
        return Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: size,
        );
      case AccountConnectionState.error:
        return Icon(
          Icons.error_outline,
          color: Colors.red,
          size: size,
        );
      case AccountConnectionState.diactivated:
        return Icon(
          Icons.do_not_disturb,
          color: Colors.grey,
          size: size,
        );
    }
  }
}
