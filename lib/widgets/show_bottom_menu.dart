import 'package:cccc/styles/text_styles.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

Future<void> showBottomMenu(
  BuildContext context, {
  required String title,
  required String subtitle,
  required IconData firstActionIconData,
  required String firstActionTitle,
  required void Function()? onFirstActionTap,
  IconData? secondActionIconData,
  String? secondActionTitle,
  void Function()? onSecondActionTap,
  IconData? thirdActionIconData,
  String? thirdActionTitle,
  void Function()? onThirdActionTap,
}) async {
  if (kIsWeb) {
  } else {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(title, style: TextStyles.h6),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(subtitle, style: TextStyles.body1Grey),
          ),
          const SizedBox(height: 16),
          ListTile(
            onTap: onFirstActionTap,
            leading: Icon(firstActionIconData),
            title: Text(firstActionTitle),
          ),
          if (secondActionTitle != null)
            ListTile(
              onTap: onSecondActionTap,
              leading: Icon(secondActionIconData),
              title: Text(secondActionTitle),
            ),
          if (thirdActionTitle != null)
            ListTile(
              onTap: onThirdActionTap,
              leading: Icon(thirdActionIconData),
              title: Text(thirdActionTitle),
            ),
        ],
      ),
    );
  }
}
