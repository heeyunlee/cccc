import 'dart:convert';

import 'package:cccc/extensions/enum_extension.dart';
import 'package:cccc/extensions/string_extension.dart';
import 'package:cccc/models/enum/account_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'balance.dart';

/// An array containing the accounts associated with the Item for which
/// transactions are being returned. Each transaction can be mapped to its
/// corresponding account via the `account_id` field.
class Account {
  Account({
    required this.accountId,
    required this.balance,
    this.mask,
    required this.name,
    this.officialName,
    required this.type,
    this.subtype,
    this.verificationStatus,
    required this.lastSyncedTime,
  });

  /// Plaid’s unique identifier for the account. This value will not change
  /// unless Plaid can't reconcile the account with the data returned by the
  /// financial institution. This may occur, for example, when the name of the
  /// account changes. If this happens a new `account_id` will be assigned to
  /// the account.
  ///
  /// The `account_id` can also change if the `access_token` is deleted and the
  /// same credentials that were used to generate that access_token are used to
  /// generate a new `access_token` on a later date. In that case, the new
  /// `account_id` will be different from the old `account_id`.
  ///
  /// If an account with a specific `account_id` disappears instead of changing,
  /// the account is likely closed. Closed accounts are not returned by the
  /// Plaid API.
  ///
  /// Like all Plaid identifiers, the `account_id` is case sensitive.
  final String accountId;

  /// A set of fields describing the balance for an account. Balance
  /// information may be cached unless the balance object was returned by
  /// `/accounts/balance/get`.
  final Balance balance;

  /// The last 2-4 alphanumeric characters of an account's official account
  /// number. Note that the mask may be non-unique between an Item's accounts,
  /// and it may also not match the mask that the bank displays to the user.
  final String? mask;

  /// The name of the account, either assigned by the user or by the financial
  /// institution itself
  final String name;

  /// The official name of the account as given by the financial institution
  final String? officialName;

  /// `investment`: Investment account. In API versions 2018-05-22 and earlier,
  /// this type is called brokerage instead.
  ///
  /// `credit`: Credit card
  ///
  /// `depository`: Depository account
  ///
  /// `loan`: Loan account
  ///
  /// `brokerage`: An investment account. Used for `/assets/` endpoints only;
  /// other endpoints use investment.
  ///
  /// `other`: Non-specified account type
  ///
  /// See the [Account type schema]('https://plaid.com/docs/api/accounts/#account-type-schema')
  /// for a full listing of account types and corresponding subtypes.
  ///
  /// Possible values: `investment`, `credit`, `depository`, `loan`,
  /// `brokerage`, `other`
  final AccountType type;

  /// See the Account type schema for a full listing of account types and
  /// corresponding subtypes.
  ///
  /// Possible values: `401a`, `401k`, `403B`, `457b`, `529`, `brokerage`,
  /// `cash isa`, `education savings account`, `ebt`, `fixed annuity`, `gic`,
  /// `health reimbursement arrangement`, `hsa`, `isa`, `ira`, `lif`,
  /// `life insurance`, `lira`, `lrif`, `lrsp`, `non-taxable brokerage account`,
  /// `other`, `other insurance`, `other annuity`, `prif`, `rdsp`, `resp`,
  /// `rlif`, `rrif`, `pension`, `profit sharing plan`, `retirement`, `roth`,
  /// `roth 401k`, `rrsp`, `sep ira`, `simple ira`, `sipp`, `stock plan`,
  /// `thrift savings plan`, `tfsa`, `trust`, `ugma`, `utma`,
  /// `variable annuity`, `credit card`, `paypal`, `cd`, `checking`, `savings`,
  /// `money market`, `prepaid`, `auto`, `business`, `commercial`,
  /// `construction`, `consumer`, `home equity`, `loan`, `mortgage`,
  /// `overdraft`, `line of credit`, `student`, `cash management`, `keogh`,
  /// `mutual fund`, `recurring`, `rewards`, `safe deposit`, `sarsep`,
  /// `payroll`, `null`
  final String? subtype;

  /// The current verification status of an Auth Item initiated through
  /// Automated or Manual micro-deposits.  Returned for Auth Items only.
  ///
  /// `pending_automatic_verification`: The Item is pending automatic
  /// verification
  ///
  /// `pending_manual_verification`: The Item is pending manual micro-deposit
  /// verification. Items remain in this state until the user successfully
  /// verifies the two amounts.
  ///
  /// `automatically_verified`: The Item has successfully been automatically
  /// verified
  ///
  /// `manually_verified`: The Item has successfully been manually verified
  ///
  /// `verification_expired`: Plaid was unable to automatically verify the
  /// deposit within 7 calendar days and will no longer attempt to validate
  /// the Item. Users may retry by submitting their information again through
  /// Link.
  ///
  /// `verification_failed`: The Item failed manual micro-deposit verification
  /// because the user exhausted all 3 verification attempts. Users may retry
  /// by submitting their information again through Link.
  ///
  /// Possible values: `automatically_verified`,
  /// `pending_automatic_verification`, `pending_manual_verification`,
  /// `manually_verified`, `verification_expired`, `verification_failed`
  final String? verificationStatus;

  /// Last synced [DateTime]
  final DateTime? lastSyncedTime;

  Account copyWith({
    String? accountId,
    Balance? balance,
    String? mask,
    String? name,
    String? officialName,
    AccountType? type,
    String? subtype,
    String? verificationStatus,
    DateTime? lastSyncedTime,
  }) {
    return Account(
      accountId: accountId ?? this.accountId,
      balance: balance ?? this.balance,
      mask: mask ?? this.mask,
      name: name ?? this.name,
      officialName: officialName ?? this.officialName,
      type: type ?? this.type,
      subtype: subtype ?? this.subtype,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      lastSyncedTime: lastSyncedTime ?? this.lastSyncedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'account_id': accountId,
      'balance': balance.toMap(),
      'mask': mask,
      'name': name,
      'official_name': officialName,
      'type': enumToString(type),
      'subtype': subtype,
      'verification_status': verificationStatus,
      'last_synced_time': lastSyncedTime,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    final String accountId = map['account_id'];
    final Balance balance = Balance.fromMap(map['balances']);
    final String? mask = map['mask'];
    final String name = map['name'];
    final String? officialName = map['official_name'];
    final AccountType type = (map['type'] as String).toEnum(AccountType.values);
    final String? subtype = map['subtype'];
    final String? verificationStatus = map['verification_status'];
    final DateTime? lastSyncedTime = map['last_synced_time'] != null
        ? (map['last_synced_time'] as Timestamp).toDate()
        : null;

    return Account(
      accountId: accountId,
      balance: balance,
      mask: mask,
      name: name,
      officialName: officialName,
      type: type,
      subtype: subtype,
      verificationStatus: verificationStatus,
      lastSyncedTime: lastSyncedTime,
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) {
    return Account.fromMap(json.decode(source));
  }

  @override
  String toString() {
    return 'Account(accountId: $accountId, balance: $balance, mask: $mask, name: $name, officialName: $officialName, type: $type, subtype: $subtype, verificationStatus: $verificationStatus, lastSyncedTime: $lastSyncedTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Account &&
        other.accountId == accountId &&
        other.balance == balance &&
        other.mask == mask &&
        other.name == name &&
        other.officialName == officialName &&
        other.type == type &&
        other.subtype == subtype &&
        other.verificationStatus == verificationStatus &&
        other.lastSyncedTime == lastSyncedTime;
  }

  @override
  int get hashCode {
    return accountId.hashCode ^
        balance.hashCode ^
        mask.hashCode ^
        name.hashCode ^
        officialName.hashCode ^
        type.hashCode ^
        subtype.hashCode ^
        verificationStatus.hashCode ^
        lastSyncedTime.hashCode;
  }
}
