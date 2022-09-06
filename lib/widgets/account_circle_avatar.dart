import 'dart:convert';

import 'package:cccc/enum/account_connection_state.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:flutter/material.dart';

import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/styles/styles.dart';

class InstitutionCircleAvatar extends StatelessWidget {
  const InstitutionCircleAvatar({
    super.key,
    required this.institution,
    required this.account,
    this.diameter = 32,
  });

  final Institution? institution;
  final Account account;
  final double? diameter;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: diameter! * 9 / 8,
          height: diameter! * 9 / 8,
          decoration: BoxDecoration(
            border: Border.all(
              color: _getBorderColor(),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(diameter!),
          ),
          child: Container(
            width: diameter! * 17 / 16,
            height: diameter! * 17 / 16,
            decoration: BoxDecoration(
              border: Border.all(
                color: ThemeColors.grey900,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(diameter!),
            ),
            child: _buildCircle(),
          ),
        ),
        if (account.accountConnectionState == AccountConnectionState.error)
          const Positioned(
            right: -2,
            bottom: -2,
            child: Icon(Icons.error, size: 12),
          ),
      ],
    );
  }

  Widget _buildCircle() {
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
      final fullHexCode = 'FF$hexCode';
      final hexCodeInt = int.parse(fullHexCode, radix: 16);

      return Container(
        width: diameter,
        height: diameter,
        decoration: Decorations.colorCircle(hexCodeInt),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: FittedBox(
              child: Text(institution!.name[0]),
            ),
          ),
        ),
      );
    }

    return Image.memory(
      base64Decode(institution!.logo!),
      width: diameter,
      height: diameter,
      fit: BoxFit.cover,
    );
  }

  Color _getBorderColor() {
    switch (account.accountConnectionState) {
      case AccountConnectionState.diactivated:
        return Colors.yellow[700]!;
      case AccountConnectionState.error:
        return Colors.red;
      case AccountConnectionState.healthy:
        return Colors.green;
    }
  }
}
