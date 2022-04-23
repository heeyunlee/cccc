part of 'button.dart';

class _ElevatedButton extends Button {
  _ElevatedButton({
    required Widget child,
    required VoidCallback? onPressed,
    VoidCallback? onLongPressed,
    Color? backgroundColor,
    bool vibrateOnPress = true,
    Duration animationDuration = const Duration(milliseconds: 100),
    Curve animationCurve = Curves.linear,
    double scaleDownTo = 0.975,
    double opacityTo = 0.9,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: kHorizontalPadding,
      vertical: kVerticalPadding,
    ),
    double borderRadius = 8,
    EdgeInsets margin = EdgeInsets.zero,
    double? width,
    double? height,
    Key? key,
  }) : super._(
          onPressed: onPressed,
          animationCurve: animationCurve,
          animationDuration: animationDuration,
          margin: margin,
          onLongPressed: onLongPressed,
          opacityTo: opacityTo,
          height: height,
          scaleDownTo: scaleDownTo,
          vibrateOnPress: vibrateOnPress,
          width: width,
          child: _ElevatedButtonChild(
            key: key,
            backgroundColor: backgroundColor,
            borderRadius: borderRadius,
            padding: padding,
            child: child,
          ),
        );
}

class _ElevatedButtonChild extends StatelessWidget {
  const _ElevatedButtonChild({
    required this.backgroundColor,
    required this.borderRadius,
    required this.padding,
    required this.child,
    Key? key,
  }) : super(key: key);

  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.primaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
