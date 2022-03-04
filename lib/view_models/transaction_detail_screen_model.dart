import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/styles/styles.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:cccc/widgets/show_adaptive_date_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cccc/models/enum/payment_channel.dart';

class TransactionDetailModel with ChangeNotifier {
  TransactionDetailModel({
    required this.transaction,
    required this.database,
  });

  final FirestoreDatabase database;
  final Transaction transaction;

  Stream<Transaction?> transactionStream(String transactionId) {
    return database.transactionStream(transactionId);
  }

  String get amount => Formatter.amount(
        transaction.amount,
        transaction.isoCurrencyCode ?? 'USD',
      );

  TextStyle get amountTextStyle =>
      transaction.amount > 0 ? TextStyles.h4W900 : TextStyles.h4W900Green;

  String get name => transaction.name;

  String get merchantName {
    return transaction.newMerchantName ??
        transaction.merchantName ??
        'No Merchant';
  }

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

  Future<Account?> get accountFuture => database.accountGet(accountId);

  Future<void> updateTransactionDate(BuildContext context) async {
    final pickedDate = await showAdaptiveDatePicker(
      context,
      initialDate: transaction.date,
    );

    if (pickedDate != null) {
      try {
        final newTransaction = {
          'date': pickedDate,
        };

        await database.updateTransaction(transaction, newTransaction);
      } on FirebaseException catch (e) {
        logger.e('Error: ${e.message}');

        await showAdaptiveDialog(
          context,
          title: 'Error',
          content: 'An error occurred. Message: ${e.message}',
          defaultActionText: 'OK',
        );
      } catch (e) {
        await showAdaptiveDialog(
          context,
          title: 'Error',
          content: 'An error occurred. Message: ${e.toString()}',
          defaultActionText: 'OK',
        );
      }
    }
  }
}
