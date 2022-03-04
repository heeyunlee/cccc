import 'dart:io';

import 'package:cccc/styles/button_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showAdaptiveDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String defaultActionText,
  bool isDefaultDestructiveAction = false,
  String? cancelAcitionText,
  bool isCancelDestructiveAction = false,
}) {
  final theme = Theme.of(context);

  if (!Platform.isIOS) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          if (cancelAcitionText != null)
            TextButton(
              style: isCancelDestructiveAction
                  ? ButtonStyles.text(foregroundColor: Colors.red)
                  : ButtonStyles.text(),
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelAcitionText),
            ),
          const SizedBox(width: 8),
          TextButton(
            style: isDefaultDestructiveAction
                ? ButtonStyles.text(foregroundColor: Colors.red)
                : ButtonStyles.text(foregroundColor: theme.primaryColor),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(defaultActionText),
          ),
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        if (cancelAcitionText != null)
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            isDefaultAction: !isCancelDestructiveAction,
            isDestructiveAction: isCancelDestructiveAction,
            child: Text(cancelAcitionText),
          ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(true),
          isDefaultAction: !isDefaultDestructiveAction,
          isDestructiveAction: isDefaultDestructiveAction,
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}
