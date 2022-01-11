import 'dart:io';

import 'package:cccc/services/firebase_storage_path.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final firebaseStorageServiceProvider =
    Provider.family<FirebaseStorageService, String>(
  (ref, uid) => FirebaseStorageService(uid: uid),
);

class FirebaseStorageService {
  FirebaseStorageService({required this.uid});

  final String uid;

  final FirebaseStorage storage = FirebaseStorage.instance;
  final picker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    final image = await picker.pickImage(source: source);

    if (image != null) {
      final file = File(image.path);

      logger.d('Got File $file');

      return file;
    } else {
      logger.d('File was not picked');
    }
  }

  Future<String?> pickAndUploadImage(ImageSource source) async {
    try {
      final image = await pickImage(source);

      if (image != null) {
        final id = DateTime.now().toIso8601String();

        final receiptId = 'receipt-id-' + uid + '-' + id;

        final ref = storage.ref(FirebaseStoragePath.receipt(uid, receiptId));

        final unit8List = await image.readAsBytes();

        final uploadTask = await ref.putData(
          unit8List,
          SettableMetadata(contentType: 'image/png'),
        );

        final taskState = uploadTask.state;

        switch (taskState) {
          case TaskState.success:
            final downloadUrl = await ref.getDownloadURL();
            logger.d('$taskState: putData() worked!');
            return downloadUrl;
          case TaskState.canceled:
            logger.d('$taskState: Task Cancelled');
            return null;
          case TaskState.error:
            logger.d('$taskState: Task ran into an error');
            return null;
          case TaskState.running:
            logger.d('$taskState: Task running');
            return null;
          case TaskState.paused:
            logger.d('$taskState: Task paused');
            return null;
        }
      } else {
        logger.e('Image was not picked...');

        return null;
      }
    } on FirebaseException catch (e) {
      logger.e('[FirebaseException]: $e');

      FirebaseException(
        plugin: 'An Error',
        message: 'An Error Occurred. Please try again',
      );

      return null;
    }
  }

  Future<String?> getResizedImage(String receiptId) async {
    final path = FirebaseStoragePath.resizedReceipt(uid, receiptId);
    logger.d('path $path');

    final ref = storage.ref(path);

    final a = await ref.getDownloadURL();

    logger.d('Downloadable URL $a');

    return a;
  }
}
