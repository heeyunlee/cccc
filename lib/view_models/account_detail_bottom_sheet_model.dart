import 'package:cccc/models/enum/account_connection_state.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/services/cloud_functions.dart';
import 'package:flutter/material.dart';

class AccountDetailBottomSheetModel with ChangeNotifier {
  AccountDetailBottomSheetModel({
    required this.functions,
    required this.account,
  });

  final CloudFunctions functions;
  final Account account;

  String get name => account.name;

  bool get connectionIsError =>
      AccountConnectionState.error == account.accountConnectionState;
}
