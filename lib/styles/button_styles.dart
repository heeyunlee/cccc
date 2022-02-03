import 'package:cccc/constants/constants.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/styles/theme_colors.dart';
import 'package:flutter/material.dart';

class ButtonStyles {
  static final outline1 = ButtonStyle(
    side: MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.any(kInteractiveStates.contains)) {
          return const BorderSide(color: Colors.grey, width: 1.0);
        }

        return const BorderSide(color: Colors.white, width: 1.0);
      },
    ),
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.any(kInteractiveStates.contains)) {
          return Colors.grey;
        }

        return Colors.white;
      },
    ),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        if (states.any(kInteractiveStates.contains)) {
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

  static final elevated1 = ButtonStyle(
    // side: MaterialStateProperty.resolveWith<BorderSide>(
    //   (Set<MaterialState> states) {
    //     if (states.any(kInteractiveStates.contains)) {
    //       return const BorderSide(color: Colors.grey, width: 1.0);
    //     }

    //     return const BorderSide(color: Colors.white, width: 1.0);
    //   },
    // ),
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.any(kInteractiveStates.contains)) {
          return ThemeColors.primary600;
        }

        return ThemeColors.primary500;
      },
    ),
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.any(kInteractiveStates.contains)) {
          return Colors.white70;
        }

        return Colors.white;
      },
    ),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        if (states.any(kInteractiveStates.contains)) {
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

  static final elevatedGrey = ElevatedButton.styleFrom(
    primary: Colors.grey,
    textStyle: TextStyles.button1,
  );

  static final text1 = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        if (states.any(kInteractiveStates.contains)) {
          return TextStyles.button1Grey;
        }

        return TextStyles.button1;
      },
    ),
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.any(kInteractiveStates.contains)) {
          return Colors.grey;
        }

        return Colors.white;
      },
    ),
  );

  static final text1Primary = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        if (states.any(kInteractiveStates.contains)) {
          return TextStyles.button1Primary300;
        }

        return TextStyles.button1Primary;
      },
    ),
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.any(kInteractiveStates.contains)) {
          return ThemeColors.primary300;
        }

        return ThemeColors.primary500;
      },
    ),
  );

  static final text1Red = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        if (states.any(kInteractiveStates.contains)) {
          return TextStyles.button1Red300;
        }

        return TextStyles.button1Red;
      },
    ),
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.any(kInteractiveStates.contains)) {
          return ThemeColors.red300;
        }

        return Colors.red;
      },
    ),
  );

  static final text2 = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        if (states.any(kInteractiveStates.contains)) {
          return TextStyles.button2Grey;
        }

        return TextStyles.button2;
      },
    ),
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.any(kInteractiveStates.contains)) {
          return Colors.grey;
        }

        return Colors.white;
      },
    ),
  );
}
