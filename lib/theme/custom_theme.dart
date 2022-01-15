import 'package:cccc/theme/text_styles.dart';
import 'package:cccc/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTheme {
  static final theme = ThemeData(
    textTheme: const TextTheme(
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
    ),
    primaryColor: ThemeColors.primary500,
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.white,
    ),
    primarySwatch: MaterialColor(
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
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyles.subtitle2,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.grey[850]!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    dividerColor: Colors.transparent,
    dividerTheme: const DividerThemeData(color: Colors.transparent),
  );
}
