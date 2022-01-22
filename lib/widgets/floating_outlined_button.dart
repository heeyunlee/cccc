import 'package:cccc/styles/decorations.dart';
import 'package:flutter/material.dart';

import 'package:cccc/styles/button_styles.dart';

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

    return Container(
      height: 80,
      width: size.width,
      decoration: Decorations.grey900Gradient,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: OutlinedButton(
          style: ButtonStyles.outline1,
          onPressed: onPressed,
          child: Text(buttonName),
        ),
      ),
    );
  }
}
