import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showAdaptiveDatePicker(
  BuildContext context, {
  required DateTime initialDate,
}) async {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    DateTime? _pickedDate;

    CupertinoDatePicker(
      onDateTimeChanged: (date) {
        _pickedDate = date;
      },
    );

    return _pickedDate;
  } else {
    final firstDate = initialDate.subtract(const Duration(days: 365 * 5));
    final lastDate = initialDate.add(const Duration(days: 365 * 5));
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    return pickedDate;
  }
}
