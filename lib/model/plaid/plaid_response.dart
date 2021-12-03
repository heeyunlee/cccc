import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cccc/model/plaid/account.dart';
import 'package:cccc/model/plaid/plaid_item.dart';
import 'package:cccc/model/plaid/transaction.dart';

class PlaidResponse {
  PlaidResponse({
    required this.accounts,
    required this.transactions,
    required this.totalTransactions,
    required this.item,
    required this.requestId,
  });

  final List<Account> accounts;
  final List<Transaction> transactions;
  final int totalTransactions;
  final PlaidItem item;
  final String requestId;

  PlaidResponse copyWith({
    List<Account>? accounts,
    List<Transaction>? transactions,
    int? totalTransactions,
    PlaidItem? item,
    String? requestId,
  }) {
    return PlaidResponse(
      accounts: accounts ?? this.accounts,
      transactions: transactions ?? this.transactions,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      item: item ?? this.item,
      requestId: requestId ?? this.requestId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accounts': accounts.map((x) => x.toMap()).toList(),
      'transactions': transactions.map((x) => x.toMap()).toList(),
      'totalTransactions': totalTransactions,
      'item': item.toMap(),
      'requestId': requestId,
    };
  }

  factory PlaidResponse.fromMap(Map<String, dynamic> map) {
    return PlaidResponse(
      accounts:
          List<Account>.from(map['accounts']?.map((x) => Account.fromMap(x))),
      transactions: List<Transaction>.from(
          map['transactions']?.map((x) => Transaction.fromMap(x))),
      totalTransactions: map['totalTransactions'],
      item: PlaidItem.fromMap(map['item']),
      requestId: map['requestId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaidResponse.fromJson(String source) =>
      PlaidResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlaidResponse(accounts: $accounts, transactions: $transactions, totalTransactions: $totalTransactions, item: $item, requestId: $requestId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaidResponse &&
        listEquals(other.accounts, accounts) &&
        listEquals(other.transactions, transactions) &&
        other.totalTransactions == totalTransactions &&
        other.item == item &&
        other.requestId == requestId;
  }

  @override
  int get hashCode {
    return accounts.hashCode ^
        transactions.hashCode ^
        totalTransactions.hashCode ^
        item.hashCode ^
        requestId.hashCode;
  }
}
