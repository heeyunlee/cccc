import 'package:flutter/material.dart';

const _shimmerGradient = LinearGradient(
  colors: [
    Colors.green,
    Colors.white,
    Colors.green,
  ],
  stops: [
    0.1,
    0.2,
    0.3,
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  tileMode: TileMode.clamp,
);

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) => _shimmerGradient.createShader(bounds),
      child: child,
    );
  }
}
