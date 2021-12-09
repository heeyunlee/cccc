import 'package:cccc/theme/text_styles.dart';
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
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyles.subtitle1,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    ),
  );
}
