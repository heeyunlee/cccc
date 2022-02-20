import 'package:cccc/models/merchant.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chooseMerchantForTransactionModelProvider = ChangeNotifierProvider
    .autoDispose
    .family<ChooseMerchantForTransactionModel, Transaction>(
  (ref, transaction) {
    final auth = ref.watch(authProvider);
    final database = ref.watch(databaseProvider(auth.currentUser!.uid));

    return ChooseMerchantForTransactionModel(
      database: database,
      transaction: transaction,
    );
  },
);

class ChooseMerchantForTransactionModel with ChangeNotifier {
  ChooseMerchantForTransactionModel({
    required this.database,
    required this.transaction,
  }) {
    _selectedMerchantIt = transaction.merchantId;
  }

  final FirestoreDatabase database;
  final Transaction transaction;

  // Stream<List<Merchant?>> get merchantStream => database.merchantsStream();

  String get originalMerchantName => transaction.merchantName ?? '';

  String? get selectedMerchantIt => _selectedMerchantIt;

  String? _selectedMerchantIt;

  void onTap(Merchant merchant) {
    _selectedMerchantIt = merchant.merchantId;
    notifyListeners();
  }
}
