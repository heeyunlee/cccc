import 'dart:io';

import 'package:cccc/models/enum/scan_receipt_state.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/models/transaction_items.dart';
import 'package:cccc/services/cloud_functions.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/services/image_picker_service.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

final scanReceiptBottomSheetModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final auth = ref.watch(authProvider);
    final uid = auth.currentUser!.uid;
    final imagePicker = ref.read(imagePickerServiceProvider);
    final functions = ref.watch(cloudFunctionsProvider);
    final database = ref.watch(databaseProvider(uid));

    return ScanReceiptBottomSheetModel(
      imagePicker: imagePicker,
      functions: functions,
      database: database,
    );
  },
);

class ScanReceiptBottomSheetModel with ChangeNotifier {
  ScanReceiptBottomSheetModel({
    required this.imagePicker,
    required this.functions,
    required this.database,
  });

  final ImagePickerService imagePicker;
  final CloudFunctions functions;
  final FirestoreDatabase database;

  File? get image => _image;
  TransactionItems? get transactionItems => _transactionItems;
  Transaction? get transaction => _transaction;
  ScanReceiptState get state => _state;
  Stream<List<Transaction?>>? get transactionsStream => _transactionsStream;

  File? _image;
  TransactionItems? _transactionItems;
  Transaction? _transaction;
  ScanReceiptState _state = ScanReceiptState.start;
  Stream<List<Transaction?>>? _transactionsStream;

  void toggleState(ScanReceiptState state) {
    _state = state;
    notifyListeners();
  }

  Map<String, double> _rawTextsToMap(RecognisedText texts) {
    final nestedLines = texts.blocks.map((e) => e.lines).toList();
    final textLines = nestedLines.expand((e) => e).toList();

    final textsWithPosition = {
      for (final line in textLines) line.text: line.rect.bottom,
    };

    return textsWithPosition;
  }

  Future<void> chooseImage(
    BuildContext context, {
    required ImageSource source,
  }) async {
    try {
      toggleState(ScanReceiptState.loading);

      final file = await imagePicker.pickImage(source);

      if (file != null) {
        _image = file;
        toggleState(ScanReceiptState.checkImage);
      } else {
        toggleState(ScanReceiptState.start);
      }
    } catch (e) {
      showAdaptiveDialog(
        context,
        title: 'Something went wrong',
        content: e.toString(),
        defaultActionText: 'OK',
      );
    }
  }

  Future<TransactionItems?> _extractTexts(BuildContext context) async {
    try {
      toggleState(ScanReceiptState.loading);

      if (_image != null) {
        logger.d('File exists. Start using [GoogleMlKit]');

        final textDetector = GoogleMlKit.vision.textDetector();
        final inputImage = InputImage.fromFile(_image!);
        final recognisedText = await textDetector.processImage(inputImage);

        final items = await functions.processReceiptTexts(
          context,
          rawTexts: recognisedText.text,
          textsWithPosition: _rawTextsToMap(recognisedText),
        );

        return items;
      } else {
        showAdaptiveDialog(
          context,
          title: 'An Error Occurred',
          content: 'Image file was not added properly. Please try again.',
          defaultActionText: 'OK',
        );
      }
    } catch (e) {
      showAdaptiveDialog(
        context,
        title: 'Something went wrong',
        content: e.toString(),
        defaultActionText: 'OK',
      );
    }
  }

  Future<void> getTransactionitems(BuildContext context) async {
    final items = await _extractTexts(context);

    if (items != null) {
      _transactionItems = items;
      logger.d('Items $items');

      toggleState(ScanReceiptState.checkTexts);
    } else {
      toggleState(ScanReceiptState.error);

      logger.d('Could not fetch items');
    }
  }

  Future<void> showMatchingTransaction(
    BuildContext context, {
    Transaction? transaction,
  }) async {
    final index = _transactionItems!.transactionItems.length - 1;
    final maxItem = _transactionItems!.transactionItems[index];
    final maxAmount = maxItem.amount;

    if (transaction != null) {
      final transactionAmount = transaction.amount;

      if (transactionAmount == maxAmount) {
        toggleState(ScanReceiptState.loading);

        _transaction = transaction;

        await _updateTransationData(context);
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
      final transactionStream = database.transactionsSpecificAmount(maxAmount);
      _transactionsStream = transactionStream;

      toggleState(ScanReceiptState.checkTransaction);
    }
  }

  Future<void> selectTransaction(
    BuildContext context, {
    required Transaction transaction,
  }) async {
    _transaction = transaction;

    await _updateTransationData(context);
  }

  Future<void> _updateTransationData(BuildContext context) async {
    if (_transaction != null) {
      final updatedTransaction = _transaction!
          .copyWith(transactionItems: _transactionItems!.transactionItems)
          .toMap();

      // Update Transactions
      await database.updateTransaction(_transaction!, updatedTransaction);

      toggleState(ScanReceiptState.completed);
    }
  }
}
