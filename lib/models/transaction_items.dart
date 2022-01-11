import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cccc/models/transaction_item.dart';

class TransactionItems {
  TransactionItems({
    required this.transactionItems,
  });

  final List<TransactionItem> transactionItems;

  TransactionItems copyWith({
    List<TransactionItem>? transactionItems,
  }) {
    return TransactionItems(
      transactionItems: transactionItems ?? this.transactionItems,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionItems': transactionItems.map((x) => x.toMap()).toList(),
    };
  }

  factory TransactionItems.fromMap(Map<String, dynamic> map) {
    final List<TransactionItem> items = List<TransactionItem>.from(
      map['transaction_items'].map((x) => TransactionItem.fromMap(x)),
    );

    return TransactionItems(
      transactionItems: items,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionItems.fromJson(String source) =>
      TransactionItems.fromMap(json.decode(source));

  @override
  String toString() => 'TransactionItems(transactionItems: $transactionItems)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionItems &&
        listEquals(other.transactionItems, transactionItems);
  }

  @override
  int get hashCode => transactionItems.hashCode;
}
