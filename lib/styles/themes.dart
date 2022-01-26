import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Themes {
  static const text = TextTheme(
    headline1: TextStyles.h1,
    headline2: TextStyles.h2,
    headline3: TextStyles.h3,
    headline4: TextStyles.h4,
    headline5: TextStyles.h5,
    headline6: TextStyles.h6,
    subtitle1: TextStyles.subtitle1,
    subtitle2: TextStyles.subtitle2,
    bodyText1: TextStyles.body1,
    bodyText2: TextStyles.body2,
    button: TextStyles.button1,
    caption: TextStyles.caption,
    overline: TextStyles.overline,
  );

  static const listTile = ListTileThemeData(
    iconColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 16,
    ),
    dense: true,
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
