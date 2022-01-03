import 'package:cccc/models/plaid/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cccc/extensions/string_extension.dart';

final transactionDetailScreenModelProvider = ChangeNotifierProvider.autoDispose
    .family<TransactionDetailScreenModel, Transaction>(
  (ref, transaction) => TransactionDetailScreenModel(transaction),
);

class TransactionDetailScreenModel with ChangeNotifier {
  TransactionDetailScreenModel(this.transaction);

  final Transaction transaction;

  String get amount {
    final f = NumberFormat.simpleCurrency(
      name: transaction.isoCurrencyCode,
      decimalDigits: 2,
    );
    final amount = f.format(transaction.amount);

    return amount;
  }

  String get name => transaction.name;

  String get merchantName => transaction.merchantName ?? 'Unknown';

  String get date {
    final f = DateFormat.yMMMMd();
    final date = f.format(transaction.date);

    return date;
  }

  String get categoryId => transaction.categoryId ?? 'Unknown';

  bool get isPending => transaction.pending;

  List<String>? get categories => transaction.category;

  String get originalDescription =>
      transaction.originalDescription ?? 'No Description';

  String get paymentChannel {
    final a = transaction.paymentChannel;

    return a.title;
  }

  String get lat => transaction.location?.lat?.toString() ?? 'Lat';
  String get lon => transaction.location?.lon?.toString() ?? 'Lon';

  bool get isFood => transaction.isFoodCategory ?? false;

  String get cityState {
    final city = transaction.location?.city ?? 'City';
    final state = transaction.location?.region ?? 'State';

    return '$city, $state';
  }
}
