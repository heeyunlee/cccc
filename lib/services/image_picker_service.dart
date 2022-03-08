import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'logger_init.dart';

/// Creates a class that interacts with [ImagePicker] library to pick image from
/// local library or camera
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Pick Image [File] from the [source]
  Future<File?> pickImage(ImageSource source) async {
    final image = await _picker.pickImage(source: source);

    if (image != null) {
      final file = File(image.path);

      logger.d('Got File $file');

      return file;
    } else {
      logger.d('File was not picked');

      return null;
    }
  }
}
