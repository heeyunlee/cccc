import 'package:cccc/styles/theme_colors.dart';
import 'package:flutter/material.dart';

class BottomSheetCard extends StatelessWidget {
  const BottomSheetCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Card(
      elevation: 6,
      clipBehavior: Clip.hardEdge,
      color: ThemeColors.grey900,
      borderOnForeground: false,
      margin: EdgeInsets.fromLTRB(8, 0, 8, padding.bottom + 8),
      child: child,
    );
  }
}
