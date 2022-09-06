import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Page adaptivePage(
  BuildContext context, {
  required Widget child,
  Object? arguments,
  bool fullscreenDialog = false,
  LocalKey? key,
  bool maintainState = true,
  String? name,
  String? restorationId,
  String? title,
}) {
  final platform = Theme.of(context).platform;

  switch (platform) {
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.windows:
    case TargetPlatform.linux:
      return MaterialPage(
        arguments: arguments,
        fullscreenDialog: fullscreenDialog,
        key: key,
        maintainState: maintainState,
        name: name,
        restorationId: restorationId,
        child: child,
      );

    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return CupertinoPage(
        arguments: arguments,
        fullscreenDialog: fullscreenDialog,
        key: key,
        maintainState: maintainState,
        name: name,
        restorationId: restorationId,
        title: title,
        child: child,
      );
  }
}
