import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'logger_init.dart';

final imagePickerServiceProvider = Provider(
  (ref) => ImagePickerService(),
);

class ImagePickerService {
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
}
