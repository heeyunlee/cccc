import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Themes {
  static const text = TextTheme(
    displayLarge: TextStyles.h1,
    displayMedium: TextStyles.h2,
    displaySmall: TextStyles.h3,
    headlineMedium: TextStyles.h4,
    headlineSmall: TextStyles.h5,
    titleLarge: TextStyles.h6,
    titleMedium: TextStyles.subtitle1,
    titleSmall: TextStyles.subtitle2,
    bodyLarge: TextStyles.body1,
    bodyMedium: TextStyles.body2,
    labelLarge: TextStyles.button1,
    bodySmall: TextStyles.caption,
    labelSmall: TextStyles.overline,
  );

  static const listTile = ListTileThemeData(
    iconColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 16,
    ),
    dense: true,
    style: ListTileStyle.list,
  );

  static const appBar = AppBarTheme(
    backgroundColor: Colors.transparent,
    titleTextStyle: TextStyles.subtitle2,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
    ),
  );

  static const bottomSheet = BottomSheetThemeData(
    backgroundColor: Colors.transparent,
    elevation: 0,
  );

  static const card = CardTheme(
    color: ThemeColors.grey900,
    margin: EdgeInsets.all(16),
    clipBehavior: Clip.hardEdge,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );

  static const divider = DividerThemeData(
    color: Colors.transparent,
  );

  static final primarySwatch = MaterialColor(
    ThemeColors.primary500.value,
    const {
      50: ThemeColors.primary050,
      100: ThemeColors.primary100,
      200: ThemeColors.primary200,
      300: ThemeColors.primary300,
      400: ThemeColors.primary400,
      500: ThemeColors.primary500,
      600: ThemeColors.primary600,
      700: ThemeColors.primary700,
      800: ThemeColors.primary800,
      900: ThemeColors.primary900,
    },
  );
}
