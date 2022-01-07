import 'package:cccc/theme/text_styles.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

Future<void> showCustomBottomSheet(
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
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      builder: (context) {
        final bottomPadding = MediaQuery.of(context).padding.bottom;

        return IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Container(
                  height: 4,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
              SizedBox(height: bottomPadding),
            ],
          ),
        );
      },
    );
  }
}
