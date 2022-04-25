import 'dart:io';

import 'package:cccc/styles/styles.dart';
import 'package:cccc/widgets/button/button.dart';
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
  if (!Platform.isIOS) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          if (cancelAcitionText != null)
            Button.text(
              onPressed: () => Navigator.of(context).pop(false),
              text: cancelAcitionText,
              textStyle: isCancelDestructiveAction
                  ? TextStyles.button1Red
                  : TextStyles.button1,
            ),
          const SizedBox(width: 8),
          Button.text(
            onPressed: () => Navigator.of(context).pop(true),
            text: defaultActionText,
            textStyle: isDefaultDestructiveAction
                ? TextStyles.button1Red
                : TextStyles.button1,
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
