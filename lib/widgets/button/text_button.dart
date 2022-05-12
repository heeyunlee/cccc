part of 'button.dart';

class _TextButton extends Button {
  _TextButton({
    required VoidCallback? onPressed,
    Widget? child,
    String? text,
    TextStyle? textStyle,
    VoidCallback? onLongPressed,
    bool vibrateOnPress = true,
    Duration animationDuration = const Duration(milliseconds: 100),
    Curve animationCurve = Curves.linear,
    double scaleDownTo = 0.975,
    double opacityTo = 0.9,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: kHorizontalPadding,
      vertical: kVerticalPadding * 2,
    ),
    EdgeInsets margin = EdgeInsets.zero,
    double? width,
    double? height,
    super.key,
  }) : super._(
          onPressed: onPressed,
          onLongPressed: onLongPressed,
          animationCurve: animationCurve,
          animationDuration: animationDuration,
          opacityTo: opacityTo,
          scaleDownTo: scaleDownTo,
          vibrateOnPress: vibrateOnPress,
          padding: padding,
          margin: margin,
          width: width,
          height: height,
          child: _TextButtonChild(
            text: text,
            textStyle: textStyle,
            padding: padding,
            key: key,
            child: child,
          ),
        );
}

class _TextButtonChild extends StatelessWidget {
  const _TextButtonChild({
    this.child,
    this.text,
    this.textStyle,
    required this.padding,
    super.key,
  }) : assert(child != null || text != null, 'provide either child or text');

  final Widget? child;
  final String? text;
  final TextStyle? textStyle;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child ?? Text(text!, style: textStyle),
    );
  }
}
