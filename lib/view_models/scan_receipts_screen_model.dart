import 'dart:io';

import 'package:cccc/models/transaction_items.dart';
import 'package:cccc/services/cloud_functions.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cccc/services/firebase_storage_service.dart';

final scanReceiptsScreenModelProvider = ChangeNotifierProvider(
  (ref) {
    final auth = ref.watch(authProvider);
    final uid = auth.currentUser!.uid;
    final storage = ref.watch(firebaseStorageServiceProvider(uid));
    final functions = ref.watch(cloudFunctionsProvider);

    return ScanReceiptsScreenModel(
      storage: storage,
      functions: functions,
    );
  },
);

class ScanReceiptsScreenModel with ChangeNotifier {
  ScanReceiptsScreenModel({
    required this.storage,
    required this.functions,
  });

  final FirebaseStorageService storage;
  final CloudFunctions functions;

  final picker = ImagePicker();
  bool isLoading = false;

  File? get image => _image;
  TransactionItems? get transactionItems => _transactionItems;

  File? _image;
  TransactionItems? _transactionItems;

  Future<void> pickAndUploadImage(
    BuildContext context, {
    required ImageSource source,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final file = await storage.pickImage(source);
      _image = file;

      if (file != null) {
        logger.d('File exists. Start using [GoogleMlKit]');

        final textDetector = GoogleMlKit.vision.textDetector();
        final inputImage = InputImage.fromFile(file);
        final RecognisedText recognisedText = await textDetector.processImage(
          inputImage,
        );

        final rawTexts = recognisedText.text;
        final nestedLines = recognisedText.blocks.map((e) => e.lines).toList();
        final textLines = nestedLines.expand((e) => e).toList();

        logger.d('Recognized Text: \n$rawTexts');

        final textsWithPosition = {
          for (final line in textLines) line.text: line.rect.bottom,
        };

        final items = await functions.processReceiptTexts(
          context,
          rawTexts: rawTexts,
          textsWithPosition: textsWithPosition,
        );

        logger.d('Items $items');

        _transactionItems = items;

        Navigator.of(context).pop();
      }
    } catch (e) {
      showAdaptiveDialog(
        context,
        title: 'Something went wrong',
        content: e.toString(),
        defaultActionText: 'OK',
      );
    }
    isLoading = false;
    notifyListeners();
  }
}
