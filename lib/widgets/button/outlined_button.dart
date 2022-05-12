part of 'button.dart';

class _OutlinedButton extends Button {
  _OutlinedButton({
    required Widget child,
    super.onPressed,
    super.onLongPressed,
    bool vibrateOnPress = true,
    Duration animationDuration = const Duration(milliseconds: 100),
    Curve animationCurve = Curves.linear,
    double scaleDownTo = 0.975,
    double opacityTo = 0.9,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: kHorizontalPadding,
      vertical: kVerticalPadding,
    ),
    Color borderColor = Colors.white,
    double borderWidth = 1,
    double borderRadius = 8,
    EdgeInsets margin = EdgeInsets.zero,
    double? width,
    double? height,
    super.key,
  }) : super._(
          animationCurve: animationCurve,
          animationDuration: animationDuration,
          opacityTo: opacityTo,
          scaleDownTo: scaleDownTo,
          vibrateOnPress: vibrateOnPress,
          padding: padding,
          margin: margin,
          width: width,
          height: height,
          child: _OutlinedButtonChild(
            borderColor: borderColor,
            borderWidth: borderWidth,
            borderRadius: borderRadius,
            padding: padding,
            key: key,
            child: child,
          ),
        );
}

class _OutlinedButtonChild extends StatelessWidget {
  const _OutlinedButtonChild({
    super.key,
    required this.child,
    required this.padding,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(color: borderColor, width: borderWidth),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
      ),
      child: Padding(
        padding: padding,
        child: Center(child: child),
      ),
    );
  }
}
