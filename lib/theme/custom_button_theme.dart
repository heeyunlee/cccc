import 'package:cccc/theme/text_styles.dart';
import 'package:flutter/material.dart';

class CustomButtonTheme {
  static final outline1 = ButtonStyle(
    side: MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return const BorderSide(color: Colors.grey, width: 1.0);
        } else if (states.contains(MaterialState.hovered)) {
          return const BorderSide(color: Colors.white, width: 1.0);
        } else {
          return const BorderSide(color: Colors.white, width: 1.0);
        }
      },
    ),
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return Colors.grey;
        } else if (states.contains(MaterialState.hovered)) {
          return Colors.grey;
        } else {
          return Colors.white;
        }
      },
    ),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return TextStyles.button1Grey;
        } else if (states.contains(MaterialState.hovered)) {
          return TextStyles.button1Grey;
        } else {
          return TextStyles.button1;
        }
      },
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
    ),
  );
}
