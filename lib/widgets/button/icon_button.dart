part of 'button.dart';

class _IconButton extends Button {
  _IconButton({
    required IconData icon,
    required VoidCallback? onPressed,
    Color iconColor = Colors.white,
    VoidCallback? onLongPressed,
    Curve animationCurve = Curves.linear,
    Duration animationDuration = const Duration(milliseconds: 100),
    double scaleDownTo = 0.975,
    double opacityTo = 0.9,
    double size = 24,
    EdgeInsets padding = const EdgeInsets.all(4),
    EdgeInsets margin = const EdgeInsets.all(4),
    bool vibrateOnPress = true,
    String? semanticLabel,
    super.key,
  }) : super._(
          onPressed: onPressed,
          animationCurve: animationCurve,
          animationDuration: animationDuration,
          margin: margin,
          onLongPressed: onLongPressed,
          opacityTo: opacityTo,
          padding: padding,
          scaleDownTo: scaleDownTo,
          vibrateOnPress: vibrateOnPress,
          child: _IconButtonChild(
            icon: icon,
            iconColor: iconColor,
            key: key,
            size: size,
            semanticLabel: semanticLabel,
          ),
        );
}

class _IconButtonChild extends StatelessWidget {
  const _IconButtonChild({
    required this.icon,
    required this.iconColor,
    required this.size,
    this.semanticLabel,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: iconColor,
      size: size,
      key: key,
      semanticLabel: semanticLabel,
    );
  }
}
