import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cccc/models/transaction_item.dart';

class ReceiptResponse {
  ReceiptResponse({
    this.transactionItems,
    this.date,
    this.name,
  });

  final List<TransactionItem>? transactionItems;
  final DateTime? date;
  final String? name;

  ReceiptResponse copyWith({
    List<TransactionItem>? transactionItems,
    DateTime? date,
    String? name,
  }) {
    return ReceiptResponse(
      transactionItems: transactionItems ?? this.transactionItems,
      date: date ?? this.date,
      name: name ?? this.name,
    );
  }

  factory ReceiptResponse.fromMap(Map<String, dynamic> map) {
    final List<TransactionItem> transactionItems = List<TransactionItem>.from(
      map['transactionItems'].map((x) => TransactionItem.fromMap(x)),
    );
    final DateTime? date =
        map['date'] == null ? null : DateTime.parse(map['date'] as String);
    final String? name = map['name'];

    return ReceiptResponse(
      transactionItems: transactionItems,
      date: date,
      name: name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionItems': transactionItems?.map((x) => x.toMap()).toList(),
      'date': date?.millisecondsSinceEpoch,
      'name': name,
    };
  }

  String toJson() => json.encode(toMap());

  factory ReceiptResponse.fromJson(String source) =>
      ReceiptResponse.fromMap(json.decode(source));

  @override
  String toString() =>
      'ReceiptResponse(transactionItems: $transactionItems, date: $date, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReceiptResponse &&
        listEquals(other.transactionItems, transactionItems) &&
        other.date == date &&
        other.name == name;
  }

  @override
  int get hashCode => transactionItems.hashCode ^ date.hashCode ^ name.hashCode;
}
