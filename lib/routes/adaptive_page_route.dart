import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Route adaptiveRoute({
  required bool rootNavigator,
  required Function(BuildContext context) builder,
}) {
  HapticFeedback.mediumImpact();

  if (Platform.isIOS) {
    return CupertinoPageRoute(
      fullscreenDialog: rootNavigator,
      builder: (context) => builder(context),
    );
  } else if (Platform.isAndroid) {
    return MaterialPageRoute(
      fullscreenDialog: rootNavigator,
      builder: (context) => builder(context),
    );
  } else {
    return MaterialPageRoute(
      fullscreenDialog: rootNavigator,
      builder: (context) => builder(context),
    );
  }
}
