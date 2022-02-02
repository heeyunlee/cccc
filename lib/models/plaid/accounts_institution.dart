import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/institution/institution.dart';

class AccountsInstitution {
  const AccountsInstitution({
    required this.institution,
    required this.accounts,
  });

  final Institution? institution;
  final List<Account?> accounts;

  AccountsInstitution copyWith({
    Institution? institution,
    List<Account?>? accounts,
  }) {
    return AccountsInstitution(
      institution: institution ?? this.institution,
      accounts: accounts ?? this.accounts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'institution': institution?.toMap(),
      'accounts': accounts.map((x) => x?.toMap()).toList(),
    };
  }

  factory AccountsInstitution.fromMap(Map<String, dynamic> map) {
    return AccountsInstitution(
      institution: map['institution'] != null
          ? Institution.fromMap(map['institution'])
          : null,
      accounts:
          List<Account?>.from(map['accounts']?.map((x) => Account.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountsInstitution.fromJson(String source) =>
      AccountsInstitution.fromMap(json.decode(source));

  @override
  String toString() =>
      'AccountsInstitution(institution: $institution, accounts: $accounts)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AccountsInstitution &&
        other.institution == institution &&
        listEquals(other.accounts, accounts);
  }

  @override
  int get hashCode => institution.hashCode ^ accounts.hashCode;
}
