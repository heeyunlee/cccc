import 'dart:convert';

import 'package:cccc/extensions/enum_extension.dart';
import 'package:cccc/extensions/string_extension.dart';
import 'package:cccc/models/enum/transaction_item_type.dart';

class TransactionItem {
  const TransactionItem({
    required this.transactionItemId,
    required this.transactionId,
    this.receiptId,
    required this.amount,
    required this.type,
    required this.name,
    required this.isoCurrencyCode,
  });

  final String transactionItemId;
  final String? transactionId;
  final String? receiptId;
  final num amount;
  final TransactionItemType type;
  final String name;
  final String isoCurrencyCode;

  TransactionItem copyWith({
    String? transactionItemId,
    String? transactionId,
    String? receiptId,
    num? amount,
    TransactionItemType? type,
    String? name,
    String? isoCurrencyCode,
  }) {
    return TransactionItem(
      transactionItemId: transactionItemId ?? this.transactionItemId,
      transactionId: transactionId ?? this.transactionId,
      receiptId: receiptId ?? this.receiptId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      name: name ?? this.name,
      isoCurrencyCode: isoCurrencyCode ?? this.isoCurrencyCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionItemId': transactionItemId,
      'transactionId': transactionId,
      'receiptId': receiptId,
      'name': name,
      'amount': amount,
      'type': enumToString(type),
      'isoCurrencyCode': isoCurrencyCode,
    };
  }

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    final String transactionItemId = map['transactionItemId'];
    final String? transactionId = map['transactionId'];
    final String? receiptId = map['receiptId'];
    final String name = map['name'];
    final TransactionItemType type =
        (map['type'] as String).toEnum(TransactionItemType.values);
    final num amount = map['amount'];
    final String isoCurrencyCode = map['isoCurrencyCode'];

    return TransactionItem(
      transactionItemId: transactionItemId,
      transactionId: transactionId,
      receiptId: receiptId,
      amount: amount,
      type: type,
      name: name,
      isoCurrencyCode: isoCurrencyCode,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionItem.fromJson(String source) =>
      TransactionItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionItem(transactionItemId: $transactionItemId, transactionId: $transactionId, receiptId: $receiptId, amount: $amount, type: $type, name: $name, isoCurrencyCode: $isoCurrencyCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionItem &&
        other.transactionItemId == transactionItemId &&
        other.transactionId == transactionId &&
        other.receiptId == receiptId &&
        other.amount == amount &&
        other.type == type &&
        other.name == name &&
        other.isoCurrencyCode == isoCurrencyCode;
  }

  @override
  int get hashCode {
    return transactionItemId.hashCode ^
        transactionId.hashCode ^
        receiptId.hashCode ^
        amount.hashCode ^
        type.hashCode ^
        name.hashCode ^
        isoCurrencyCode.hashCode;
  }
}
