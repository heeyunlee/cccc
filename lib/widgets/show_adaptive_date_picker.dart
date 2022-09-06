import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showAdaptiveDatePicker(
  BuildContext context, {
  required DateTime initialDate,
}) async {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    DateTime? pickedDate;

    CupertinoDatePicker(
      onDateTimeChanged: (date) {
        pickedDate = date;
      },
    );

    return pickedDate;
  } else {
    final firstDate = initialDate.subtract(const Duration(days: 365 * 5));
    final lastDate = initialDate.add(const Duration(days: 365 * 5));

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      useRootNavigator: false,
    );

    return pickedDate;
  }
}
