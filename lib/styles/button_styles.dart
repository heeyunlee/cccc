import 'package:cccc/constants/constants.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:flutter/material.dart';

/// class with the list of custom-created [ButtonStyle]
class ButtonStyles {
  /// Creates [ButtonStyle] for the [OutlinedButton] widget with the custom
  /// interactive styles.
  ///
  /// User can specify the button's width, height, or shrink ratio.
  ///
  /// If not specified, the default values for params are:
  /// [width] = `MediaQuery.of(context).size.width - 48`
  /// [height] = `48`
  /// [shrinkRatio] = `0.985`
  ///
  /// When the button is active, the colors of border, foreground, and text will
  /// be [Colors.white], and when the button is in [kInteractiveStates], the
  /// colors will change to [Colors.white70]
  static ButtonStyle outline(
    BuildContext context, {
    double? width,
    double height = 56,
    double shrinkRatio = 0.985,
  }) {
    return ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      fixedSize: MaterialStateProperty.resolveWith<Size>(
        (states) {
          final Size size = MediaQuery.of(context).size;
          final double buttonWidth = width ?? size.width - 48;

          if (states.any(kInteractiveStates.contains)) {
            return Size(buttonWidth * shrinkRatio, height * shrinkRatio);
          }

          return Size(buttonWidth, height);
        },
      ),
      side: MaterialStateProperty.resolveWith<BorderSide>(
        (Set<MaterialState> states) {
          if (states.any(kInteractiveStates.contains)) {
            return const BorderSide(color: Colors.white70, width: 1.0);
          }

          return const BorderSide(color: Colors.white, width: 1.0);
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
      textStyle: MaterialStateProperty.all<TextStyle>(TextStyles.button2),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
      ),
    );
  }

  /// Creates [ButtonStyle] for the [ElevatedButton] widget with the custom
  /// interactive styles.
  ///
  /// User can specify the button's width, height, shrink ratio, and radius.
  ///
  /// If not specified, the default values for params are:
  /// [width] = `MediaQuery.of(context).size.width - 48`
  /// [height] = `48`
  /// [shrinkRatio] = `0.985`
  /// [radius] = 8
  ///
  /// When the button is active, the colors of border, foreground, and text will
  /// be [Colors.white], and when the button is in [kInteractiveStates], the
  /// colors will change to [Colors.white70]
  static ButtonStyle elevated(
    BuildContext context, {
    Color? backgroundColor,
    double? width,
    double height = 48,
    double shrinkRatio = 0.985,
    double radius = 8,
  }) {
    return ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          final colorScheme = Theme.of(context).colorScheme;

          if (states.any(kInteractiveStates.contains)) {
            return Color.alphaBlend(
              Colors.black12,
              backgroundColor ?? colorScheme.primary,
            );
          }

          return backgroundColor ?? colorScheme.primary;
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
      textStyle: MaterialStateProperty.all<TextStyle>(TextStyles.button2),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      fixedSize: MaterialStateProperty.resolveWith<Size>(
        (Set<MaterialState> states) {
          final size = MediaQuery.of(context).size;
          final double buttonWidth = width ?? size.width - 48;

          if (states.any(kInteractiveStates.contains)) {
            return Size(buttonWidth * shrinkRatio, height * shrinkRatio);
          }

          return Size(buttonWidth, height);
        },
      ),
    );
  }

  /// Creates [ButtonStyle] for the [TextButton] widget with the custom
  /// interactive styles.
  ///
  /// User can specify the button's [TextStyle] and [foregroundColor]
  ///
  /// When the button is active, the colors of the text will be [Colors.white]
  /// or specified [foregroundColor], and when the button is in [kInteractiveStates],
  /// the opacity of the colors will decrease to 70%
  static ButtonStyle text({
    Color foregroundColor = Colors.white,
    TextStyle textStyle = TextStyles.button1,
  }) {
    return ButtonStyle(
      alignment: Alignment.center,
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      textStyle: MaterialStateProperty.resolveWith<TextStyle>(
        (Set<MaterialState> states) {
          return textStyle;
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.any(kInteractiveStates.contains)) {
            return foregroundColor.withOpacity(0.70);
          }

          return foregroundColor;
        },
      ),
    );
  }
}
