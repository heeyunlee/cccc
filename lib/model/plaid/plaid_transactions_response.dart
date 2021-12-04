import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cccc/model/plaid/account.dart';
import 'package:cccc/model/plaid/plaid_item.dart';
import 'package:cccc/model/plaid/transaction.dart';

class PlaidTransactionResponse {
  PlaidTransactionResponse({
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

  PlaidTransactionResponse copyWith({
    List<Account>? accounts,
    List<Transaction>? transactions,
    int? totalTransactions,
    PlaidItem? item,
    String? requestId,
  }) {
    return PlaidTransactionResponse(
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

  factory PlaidTransactionResponse.fromMap(Map<String, dynamic> map) {
    final List<Account> accounts = List<Account>.from(
      map['accounts'].map((e) => Account.fromMap(e)),
    );
    final List<Transaction> transactions = List<Transaction>.from(
      map['transactions'].map((e) => Transaction.fromMap(e)),
    );
    final int totalTransactions = map['total_transactions'];
    final PlaidItem item = PlaidItem.fromMap(map['item']);
    final String requestId = map['request_id'];

    return PlaidTransactionResponse(
      accounts: accounts,
      transactions: transactions,
      totalTransactions: totalTransactions,
      item: item,
      requestId: requestId,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaidTransactionResponse.fromJson(String source) {
    return PlaidTransactionResponse.fromMap(json.decode(source));
  }

  @override
  String toString() {
    return 'PlaidResponse(accounts: $accounts, transactions: $transactions, totalTransactions: $totalTransactions, item: $item, requestId: $requestId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaidTransactionResponse &&
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
