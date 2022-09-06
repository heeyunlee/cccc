import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cccc/providers.dart' show scanReceiptBottomSheetModelProvider;

class ChooseImageToScanWidget extends ConsumerWidget {
  const ChooseImageToScanWidget({
    super.key,
    this.title,
    this.subtitle,
  });

  final Widget? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) title!,
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(subtitle!),
          ),
        ListTile(
          onTap: () => ref
              .read(scanReceiptBottomSheetModelProvider)
              .chooseImageAndExtractTexts(context, source: ImageSource.camera),
          leading: const Icon(Icons.camera_alt),
          title: const Text('Camera'),
        ),
        ListTile(
          onTap: () => ref
              .read(scanReceiptBottomSheetModelProvider)
              .chooseImageAndExtractTexts(context, source: ImageSource.gallery),
          leading: const Icon(Icons.collections),
          title: const Text('Gallery'),
        ),
      ],
    );
  }
}
