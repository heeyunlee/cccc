import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Route adaptiveRoute({
  required bool rootNavigator,
  required bool maintainState,
  required Function(BuildContext context) builder,
  required RouteSettings settings,
}) {
  HapticFeedback.mediumImpact();

  if (!kIsWeb && Platform.isIOS) {
    return CupertinoPageRoute(
      fullscreenDialog: rootNavigator,
      settings: settings,
      maintainState: maintainState,
      builder: (context) => builder(context),
    );
  } else if (!kIsWeb && Platform.isAndroid) {
    return MaterialPageRoute(
      fullscreenDialog: rootNavigator,
      settings: settings,
      maintainState: maintainState,
      builder: (context) => builder(context),
    );
  } else {
    return MaterialPageRoute(
      fullscreenDialog: rootNavigator,
      settings: settings,
      maintainState: maintainState,
      builder: (context) => builder(context),
    );
  }
}
