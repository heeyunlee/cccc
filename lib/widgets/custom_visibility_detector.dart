import 'package:cccc/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CustomVisibilityDetector extends ConsumerWidget {
  const CustomVisibilityDetector({
    required this.child,
    required this.widgetName,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final String widgetName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VisibilityDetector(
      key: Key(widgetName),
      onVisibilityChanged:
          ref.read(widgetVisibilityProvider).onVisibilityChanged,
      child: child,
    );
  }
}
