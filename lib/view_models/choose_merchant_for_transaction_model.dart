import 'package:cccc/models/merchant.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/services/database.dart';
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

  Future<bool> updateTransactionMerchant() async {
    if (_selectedMerchant != null) {
      _toggleIsLoading();

      final newTransaction = {
        'merchant_id': _selectedMerchantId,
        'new_merchant_name': _selectedMerchant!.name,
      };

      try {
        await database.updateTransaction(transaction, newTransaction);
        _toggleIsLoading();

        return true;
      } catch (e) {
        _toggleIsLoading();

        return false;
      }
    }

    return false;
  }
}
