import 'package:cccc/styles/theme_colors.dart';
import 'package:flutter/material.dart';

class Decorations {
  static BoxDecoration gradientFromHexString(String? hex) {
    final hexCode = hex?.substring(1) ?? '000000';
    final fullHexCode = 'FF' + hexCode;
    final hexCodeInt = int.parse(fullHexCode, radix: 16);

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(hexCodeInt),
          Colors.black,
        ],
      ),
    );
  }

  static BoxDecoration transactionDetail(BuildContext context) => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor,
            Colors.black,
          ],
        ),
      );

  static const white24Radius8 = BoxDecoration(
    border: Border.fromBorderSide(
      BorderSide(color: Colors.white24),
    ),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static const grey900Gradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        ThemeColors.grey900,
      ],
    ),
  );

  static const blackToTransGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black,
        Colors.transparent,
      ],
    ),
  );

  static const transToBlackGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        Colors.black,
      ],
    ),
  );

  static const blueGreyCircle = BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.blueGrey,
  );

  static BoxDecoration colorCircle(int value) => BoxDecoration(
        shape: BoxShape.circle,
        color: Color(value),
      );
}
