import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/institution/institution.dart';

class AccountDetailsScreenExtra {
  const AccountDetailsScreenExtra({
    required this.account,
    required this.institution,
  });

  final Account account;
  final Institution? institution;
}
