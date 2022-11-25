import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cccc/extensions/list_extension.dart';
import 'package:cccc/enum/scan_receipt_state.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/models/transaction_item.dart';
import 'package:cccc/services/cloud_functions.dart';
import 'package:cccc/services/database.dart';
import 'package:cccc/services/image_picker_service.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';

class ScanReceiptBottomSheetModel with ChangeNotifier {
  ScanReceiptBottomSheetModel({
    required this.imagePicker,
    required this.functions,
    required this.database,
  });

  final ImagePickerService imagePicker;
  final CloudFunctions functions;
  final Database database;

  List<DateTime>? get dates => _dates;
  List<TransactionItem>? get transactionItems => _transactionItems;
  TransactionItem? get subtotalItem => _subtotalItem;
  Transaction? get transaction => _transaction;
  ScanReceiptState get state => _state;
  Stream<List<Transaction?>>? get transactionsStream => _transactionsStream;

  List<DateTime>? _dates;
  List<TransactionItem>? _transactionItems;
  TransactionItem? _subtotalItem;
  Transaction? _transaction;
  ScanReceiptState _state = ScanReceiptState.start;
  Stream<List<Transaction?>>? _transactionsStream;

  void toggleState(ScanReceiptState state) {
    _state = state;
    notifyListeners();
  }

  // TODO(heeyunlee): uncomment this
  // List<Map<String, dynamic>> _getTextsWithOffsets(RecognizedText texts) {
  //   logger.d('`_getTextsWithOffsets` function called');

  //   final nestedLines = texts.blocks.map((e) => e.lines).toList();
  //   final textLines = nestedLines.expand((e) => e).toList();
  //   final textElements = textLines.expand((e) => e.elements).toList();
  //   final textElementsMap = textElements.map((e) => e.toMap).toList();

  //   logger.d('Text Elements = ${textElementsMap.toString()}');

  //   return textElementsMap;
  // }

  // Future<ReceiptResponse?> _extractTexts(File imageFile) async {
  //   logger.d('File exists. Start using [GoogleMlKit]');

  //   final textDetector = TextRecognizer(script: TextRecognitionScript.latin);
  //   final inputImage = InputImage.fromFile(imageFile);
  //   final recognisedText = await textDetector.processImage(inputImage);
  //   final textsWithOffsets = _getTextsWithOffsets(recognisedText);
  //   final response = await functions.processReceiptTexts(
  //     rawTexts: recognisedText.text.replaceAll('\n', ', '),
  //     textsWithOffsets: textsWithOffsets,
  //   );
  //   textDetector.close();

  //   return response;
  // }

  void onItemNameChanged(String value, int index) {
    final itemToUpdate = _transactionItems![index];
    final newItem = itemToUpdate.copyWith(name: value);
    _transactionItems![index] = newItem;
  }

  void onItemAmountChanged(String value, int index) {
    final itemToUpdate = _transactionItems![index];
    final newItem = itemToUpdate.copyWith(amount: int.tryParse(value));
    _transactionItems![index] = newItem;

    final newSubtotal = _transactionItems!.map((e) => e.amount).toList().sum;

    _subtotalItem = _subtotalItem!.copyWith(amount: newSubtotal);

    notifyListeners();
  }

  Future<void> chooseImageAndExtractTexts(
    BuildContext context, {
    required ImageSource source,
  }) async {
    try {
      // toggleState(ScanReceiptState.loading);

      // final file = await imagePicker.pickImage(source);

      // if (file != null) {
      //   final receiptResponse = await _extractTexts(file);

      //   if (receiptResponse != null) {
      //     _subtotalItem = receiptResponse.transactionItems?.last;

      //     receiptResponse.transactionItems!.removeLast();
      //     _transactionItems = receiptResponse.transactionItems;
      //     _dates = receiptResponse.dates;

      //     logger.d('Dates $_dates');

      //     toggleState(ScanReceiptState.editItems);
      //   } else {
      //     toggleState(ScanReceiptState.error);
      //   }
      // } else {
      //   toggleState(ScanReceiptState.start);
      // }
    } catch (e) {
      logger.e('Error Occurred: ${e.toString()}');

      showAdaptiveDialog(
        context,
        title: 'Something went wrong',
        content: e.toString(),
        defaultActionText: 'OK',
      );
    }
  }

  Future<void> showMatchingTransaction(
    BuildContext context, {
    Transaction? transaction,
  }) async {
    final subtotal = _subtotalItem!.amount;

    if (transaction != null) {
      final transactionAmount = transaction.amount;

      if (transactionAmount == subtotal) {
        toggleState(ScanReceiptState.loading);

        _transaction = transaction;

        await _updateTransactionItems(context);
      } else {
        showAdaptiveDialog(
          context,
          title: 'The price does not match',
          content:
              'The total amount from this bank transaction does not match the scanned item. Please use a different image',
          defaultActionText: 'OK',
        );
        toggleState(ScanReceiptState.start);
      }
    } else {
      final transactionStream =
          database.transactionsStreamSpecificAmount(subtotal);
      _transactionsStream = transactionStream;

      toggleState(ScanReceiptState.chooseTransaction);
    }
  }

  Future<void> selectTransaction(
    BuildContext context, {
    required Transaction transaction,
  }) async {
    _transaction = transaction;

    await _updateTransactionItems(context);
  }

  Future<void> _updateTransactionItems(BuildContext context) async {
    try {
      final newTransaction = _transaction!.copyWith(
        transactionItems: _transactionItems,
      );

      await database.updateTransaction(_transaction!, newTransaction.toMap());

      toggleState(ScanReceiptState.completed);
    } catch (e) {
      showAdaptiveDialog(
        context,
        title: 'Something went wrong',
        content: e.toString(),
        defaultActionText: 'OK',
      );
    }
  }
}
