import 'package:flutter/material.dart';

enum AccountType {
  investment,
  credit,
  depository,
  loan,
  brokerage,
  other,
}

extension AccountTypeExtension on AccountType {
  String get str {
    switch (this) {
      case AccountType.investment:
        return 'Investment';
      case AccountType.credit:
        return 'Credit';
      case AccountType.depository:
        return 'Depository';
      case AccountType.loan:
        return 'Loan';
      case AccountType.brokerage:
        return 'Brokerage';
      case AccountType.other:
        return 'Other';
      default:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case AccountType.investment:
        return Icons.attach_money;
      case AccountType.credit:
        return Icons.credit_card;
      case AccountType.depository:
        return Icons.account_balance;
      case AccountType.loan:
        return Icons.money_outlined;
      case AccountType.brokerage:
        return Icons.attach_money;
      case AccountType.other:
        return Icons.attach_money;
      default:
        return Icons.attach_money;
    }
  }
}
