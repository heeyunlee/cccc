import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final scanReceiptsScreenModelProvider = ChangeNotifierProvider(
  (ref) => ScanReceiptsScreenModel(),
);

class ScanReceiptsScreenModel with ChangeNotifier {
  final picker = ImagePicker();

  Future<void> openCamera(BuildContext context) async {
    final image = await picker.pickImage(source: ImageSource.camera);

    print(image);

    Navigator.of(context).pop();
  }

  Future<void> openGallery(BuildContext context) async {
    final image = await picker.pickImage(source: ImageSource.gallery);

    print(image);

    Navigator.of(context).pop();
  }
}
