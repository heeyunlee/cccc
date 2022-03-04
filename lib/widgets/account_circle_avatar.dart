import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/styles/styles.dart';

class InstitutionCircleAvatar extends StatelessWidget {
  const InstitutionCircleAvatar({
    Key? key,
    required this.institution,
    this.diameter = 32,
  }) : super(key: const ValueKey('InstitutionCircleAvatar'));

  final Institution? institution;
  final double? diameter;

  @override
  Widget build(BuildContext context) {
    if (institution == null) {
      return Container(
        width: diameter,
        height: diameter,
        decoration: Decorations.blueGreyCircle,
        child: Center(
          child: Text(institution?.name[0] ?? 'I', style: TextStyles.body2),
        ),
      );
    }

    if (institution!.logo == null) {
      final hexCode = institution!.primaryColor?.substring(1) ?? '000000';
      final fullHexCode = 'FF' + hexCode;
      final hexCodeInt = int.parse(fullHexCode, radix: 16);

      return Container(
        width: diameter,
        height: diameter,
        decoration: Decorations.colorCircle(hexCodeInt),
        child: Center(child: Text(institution!.name[0])),
      );
    }

    return Image.memory(
      base64Decode(institution!.logo!),
      width: diameter,
      height: diameter,
    );
  }
}
