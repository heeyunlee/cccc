import 'package:cccc/theme/custom_button_theme.dart';
import 'package:flutter/material.dart';

class RecentTranscationsCardHeader extends StatelessWidget {
  const RecentTranscationsCardHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 4,
      ),
      child: Row(
        children: [
          const Text('Recent Transactions'),
          const Spacer(),
          TextButton(
            onPressed: () {},
            style: CustomButtonTheme.text2,
            child: const Text('VIEW ALL'),
          ),
        ],
      ),
    );
  }
}
