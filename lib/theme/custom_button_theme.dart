import 'package:cccc/constants/constants.dart';
import 'package:cccc/theme/text_styles.dart';
import 'package:flutter/material.dart';

class CustomButtonTheme {
  static final outline1 = ButtonStyle(
    side: MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.any(interactiveStates.contains)) {
          return const BorderSide(color: Colors.grey, width: 1.0);
        }

        return const BorderSide(color: Colors.white, width: 1.0);
      },
    ),
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.any(interactiveStates.contains)) {
          return Colors.grey;
        }

        return Colors.white;
      },
    ),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        if (states.any(interactiveStates.contains)) {
          return TextStyles.button1Grey;
        }

        return TextStyles.button1;
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

  static final text1 = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        if (states.any(interactiveStates.contains)) {
          return TextStyles.button1Grey;
        }

        return TextStyles.button1;
      },
    ),
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.any(interactiveStates.contains)) {
          return Colors.grey;
        }

        return Colors.white;
      },
    ),
  );

  static final text2 = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        if (states.any(interactiveStates.contains)) {
          return TextStyles.button2Grey;
        }

        return TextStyles.button2;
      },
    ),
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.any(interactiveStates.contains)) {
          return Colors.grey;
        }

        return Colors.white;
      },
    ),
  );
}
