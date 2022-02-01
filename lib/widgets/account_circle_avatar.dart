import 'dart:convert';

import 'package:cccc/styles/decorations.dart';
import 'package:flutter/material.dart';

import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/styles/text_styles.dart';

class AccountCircleAvatar extends StatelessWidget {
  const AccountCircleAvatar({
    Key? key,
    required this.account,
    required this.institution,
    this.diameter = 32,
  }) : super(key: key);

  final Account account;
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
          child: Text(account.name[0], style: TextStyles.body2),
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
