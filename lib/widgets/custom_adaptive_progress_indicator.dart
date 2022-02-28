import 'package:flutter/material.dart';

class CustomAdaptiveProgressIndicator extends StatelessWidget {
  const CustomAdaptiveProgressIndicator({
    Key? key,
    this.diameter = 24,
    this.color,
  }) : super(key: key);

  final double diameter;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter,
      height: diameter,
      child: CircularProgressIndicator.adaptive(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}
