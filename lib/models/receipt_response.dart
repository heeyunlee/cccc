import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cccc/models/transaction_item.dart';

class ReceiptResponse {
  ReceiptResponse({
    this.transactionItems,
    required this.dates,
  });

  final List<TransactionItem>? transactionItems;
  final List<DateTime> dates;

  ReceiptResponse copyWith({
    List<TransactionItem>? transactionItems,
    List<DateTime>? dates,
  }) {
    return ReceiptResponse(
      transactionItems: transactionItems ?? this.transactionItems,
      dates: dates ?? this.dates,
    );
  }

  factory ReceiptResponse.fromMap(Map<String, dynamic> map) {
    return ReceiptResponse(
      transactionItems: map['transactionItems'] != null
          ? List<TransactionItem>.from(
              map['transactionItems']?.map((x) => TransactionItem.fromMap(x)))
          : null,
      dates:
          List<DateTime>.from(map['dates']?.map((x) => DateTime.tryParse(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionItems': transactionItems?.map((x) => x.toMap()).toList(),
      'dates': dates.map((x) => x.toString()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory ReceiptResponse.fromJson(String source) =>
      ReceiptResponse.fromMap(json.decode(source));

  @override
  String toString() =>
      'ReceiptResponse(transactionItems: $transactionItems, dates: $dates)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReceiptResponse &&
        listEquals(other.transactionItems, transactionItems) &&
        listEquals(other.dates, dates);
  }

  @override
  int get hashCode => transactionItems.hashCode ^ dates.hashCode;
}
