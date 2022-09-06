import 'package:cccc/enum/account_connection_state.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cccc/enum/account_subtype.dart';
import 'package:cccc/enum/account_type.dart';
import 'package:cccc/extensions/datetime_extension.dart';

class AccountDetailModel with ChangeNotifier {
  AccountDetailModel({
    required this.account,
    required this.database,
  });

  final Account account;
  final Database database;

  String get name => account.officialName ?? account.name;

  String get title => account.subtype?.title ?? account.type.str;

  String get mask =>
      '**${account.mask} • ${account.subtype?.title ?? account.type.str}';

  String get currentAmount {
    final f = NumberFormat.simpleCurrency(
      name: account.balance.isoCurrencyCode,
      decimalDigits: 2,
    );
    final amount = f.format(account.balance.current);

    return amount;
  }

  Stream<List<Transaction?>> get transactionsStream {
    return database.transactionsStreamForSpecificAccount(account.accountId, 12);
  }

  Stream<Institution?> get institutionStream {
    return database.institutionStream(account.institutionId);
  }

  String get lastSyncedDate {
    final accountLastSyncedTime = account.accountLastSyncedTime;

    if (accountLastSyncedTime != null) {
      return 'Last synced ${accountLastSyncedTime.timeago}';
    } else {
      return 'Last synced time not available';
    }
  }

  Icon get connectionStateIcon {
    switch (account.accountConnectionState) {
      case AccountConnectionState.healthy:
        return const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 16,
        );
      case AccountConnectionState.error:
        return const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 16,
        );
      case AccountConnectionState.diactivated:
        return const Icon(
          Icons.do_not_disturb,
          color: Colors.grey,
          size: 16,
        );
    }
  }
}
