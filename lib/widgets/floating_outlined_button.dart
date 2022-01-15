import 'package:flutter/material.dart';

import 'package:cccc/theme/custom_button_theme.dart';

class FloatingOutlinedButton extends StatelessWidget {
  const FloatingOutlinedButton({
    Key? key,
    required this.buttonName,
    required this.onPressed,
  }) : super(key: key);

  final String buttonName;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Container(
      height: 80 + padding.bottom,
      width: size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black87,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 16 + padding.bottom,
        ),
        child: OutlinedButton(
          style: CustomButtonTheme.outline1,
          onPressed: onPressed,
          child: Text(buttonName),
        ),
      ),
    );
  }
}
