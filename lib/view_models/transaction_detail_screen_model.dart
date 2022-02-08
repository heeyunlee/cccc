import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cccc/models/enum/payment_channel.dart';

final transactionDetailScreenModelProvider = ChangeNotifierProvider.autoDispose
    .family<TransactionDetailScreenModel, Transaction>((ref, transaction) {
  final auth = ref.watch(authProvider);
  final database = ref.watch(databaseProvider(auth.currentUser!.uid));

  return TransactionDetailScreenModel(
    transaction: transaction,
    database: database,
  );
});

class TransactionDetailScreenModel with ChangeNotifier {
  TransactionDetailScreenModel({
    required this.transaction,
    required this.database,
  });

  final Transaction transaction;
  final FirestoreDatabase database;

  String get amount => Formatter.amount(
        transaction.amount,
        transaction.isoCurrencyCode ?? 'USD',
      );

  TextStyle get amountTextStyle =>
      transaction.amount > 0 ? TextStyles.h4W900 : TextStyles.h4W900Green;

  String get name => transaction.name;

  String get merchantName => transaction.merchantName ?? 'Unknown';

  String get date {
    final f = DateFormat.yMMMMd();
    final date = f.format(transaction.date);

    return date;
  }

  String get categoryId => transaction.categoryId ?? 'Unknown';

  bool get isPending => transaction.pending;

  List<String> get categories => transaction.category ?? [];

  String get originalDescription =>
      transaction.originalDescription ?? 'No Description';

  String get paymentChannel {
    final a = transaction.paymentChannel;

    return a.str;
  }

  String get lat => transaction.location?.lat?.toString() ?? 'Lat';
  String get lon => transaction.location?.lon?.toString() ?? 'Lon';

  bool get isFood => transaction.isFoodCategory ?? false;

  String get cityState {
    final city = transaction.location?.city ?? 'City';
    final state = transaction.location?.region ?? 'State';

    return '$city, $state';
  }

  String get accountId => transaction.accountId;

  String accountName(Account? account) {
    if (account == null) {
      return 'Not Found';
    }

    return account.name;
  }

  Stream<Account?> get acocuntStream => database.accountStream(accountId);
}
