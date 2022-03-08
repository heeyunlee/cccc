import 'package:cccc/models/merchant.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/services/database.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseException;
import 'package:flutter/material.dart';

class ChooseMerchantForTransactionModel with ChangeNotifier {
  ChooseMerchantForTransactionModel({
    required this.database,
    required this.transaction,
  }) {
    _selectedMerchantId = transaction.merchantId;
  }

  final Database database;
  final Transaction transaction;

  String? get selectedMerchantId => _selectedMerchantId;
  String get originalMerchantName => transaction.merchantName ?? '';
  Merchant? get selectedMerchant => _selectedMerchant;
  bool get isLoading => _isLoading;

  late String? _selectedMerchantId;
  Merchant? _selectedMerchant;
  bool _isLoading = false;

  void _toggleIsLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void setSelectedMerchant(Merchant merchant) {
    _selectedMerchant = merchant;
    _selectedMerchantId = merchant.merchantId;
    notifyListeners();
  }

  Future<void> updateTransactionMerchant(BuildContext context) async {
    if (_selectedMerchant != null) {
      _toggleIsLoading();

      final newTransaction = {
        'merchant_id': _selectedMerchantId,
        'new_merchant_name': _selectedMerchant!.name,
      };

      try {
        await database.updateTransaction(transaction, newTransaction);
        _toggleIsLoading();

        Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        await showAdaptiveDialog(
          context,
          title: 'Error',
          content: 'An error occurred! ${e.message}',
          defaultActionText: 'OK',
        );
      } catch (e) {
        await showAdaptiveDialog(
          context,
          title: 'Error',
          content: 'An error occurred! ${e.toString()}',
          defaultActionText: 'OK',
        );
      }
    }
  }
}
