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
      horizontal: kHorizontalPadding / 2,
      vertical: kVerticalPadding,
    ),
    EdgeInsets margin = EdgeInsets.zero,
    double? width,
    double? height,
    Key? key,
  }) : super(
          onPressed: onPressed,
          onLongPressed: onLongPressed,
          animationCurve: animationCurve,
          animationDuration: animationDuration,
          key: key,
          opacityTo: opacityTo,
          scaleDownTo: scaleDownTo,
          vibrateOnPress: vibrateOnPress,
          padding: padding,
          margin: margin,
          width: width,
          height: height,
          child: _TextButtonChild(
            child: child,
            text: text,
            textStyle: textStyle,
          ),
        );
}

class _TextButtonChild extends StatelessWidget {
  const _TextButtonChild({
    Key? key,
    this.child,
    this.text,
    this.textStyle,
  })  : assert(child != null || text != null, 'provide either child or text'),
        super(key: key);

  final Widget? child;
  final String? text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    if (child != null) return child!;

    return Center(
      child: Text(
        text!,
        style: textStyle,
      ),
    );
  }
}
