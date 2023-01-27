import 'package:cccc/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'outlined_button.dart';
part 'text_button.dart';
part 'icon_button.dart';
part 'elevated_button.dart';

/// Creates a customizable and tappable widget that bounces and increase in opacity,
///  similar to Spotify's iOS app.
class Button extends StatefulWidget {
  const Button._({
    required this.child,
    required this.onPressed,
    this.onLongPressed,
    this.vibrateOnPress = true,
    this.animationDuration = const Duration(milliseconds: 100),
    this.animationCurve = Curves.linear,
    this.scaleDownTo = 0.975,
    this.opacityTo = 0.9,
    this.padding = const EdgeInsets.all(4),
    this.margin = const EdgeInsets.symmetric(
      horizontal: kHorizontalPadding,
      vertical: kVerticalPadding,
    ),
    this.width,
    this.height,
    super.key,
  })  : assert(0 <= scaleDownTo && scaleDownTo <= 1,
            'scaleDownTo has to be between 0 and 1'),
        assert(0 <= opacityTo && opacityTo <= 1,
            'opacityTo has to be between 0 and 1');

  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final bool vibrateOnPress;
  final Duration animationDuration;
  final Curve animationCurve;
  final double scaleDownTo;
  final double opacityTo;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double? width;
  final double? height;

  /// Creates outlined button
  factory Button.outlined({
    required Widget child,
    required VoidCallback? onPressed,
    VoidCallback? onLongPressed,
    bool vibrateOnPress,
    Duration animationDuration,
    Curve animationCurve,
    double scaleDownTo,
    double opacityTo,
    EdgeInsets padding,
    EdgeInsets margin,
    Color borderColor,
    double borderWidth,
    double borderRadius,
    double width,
    double height,
    Key? key,
  }) = _OutlinedButton;

  /// Creates text button
  factory Button.text({
    required VoidCallback? onPressed,
    Widget? child,
    String? text,
    TextStyle? textStyle,
    VoidCallback? onLongPressed,
    bool vibrateOnPress,
    Duration animationDuration,
    Curve animationCurve,
    double scaleDownTo,
    double opacityTo,
    EdgeInsets padding,
    EdgeInsets margin,
    double width,
    double height,
    Key? key,
  }) = _TextButton;

  /// Creates icon button
  factory Button.icon({
    required IconData icon,
    required VoidCallback? onPressed,
    Color iconColor,
    VoidCallback? onLongPressed,
    Curve animationCurve,
    bool vibrateOnPress,
    Duration animationDuration,
    double scaleDownTo,
    double opacityTo,
    EdgeInsets padding,
    EdgeInsets margin,
    double size,
    String? semanticLabel,
    Key? key,
  }) = _IconButton;

  /// Creates outlined button
  factory Button.elevated({
    required Widget child,
    required VoidCallback? onPressed,
    VoidCallback? onLongPressed,
    Color backgroundColor,
    bool vibrateOnPress,
    Duration animationDuration,
    Curve animationCurve,
    double scaleDownTo,
    double opacityTo,
    EdgeInsets padding,
    EdgeInsets margin,
    double borderRadius,
    double width,
    double height,
    Key? key,
  }) = _ElevatedButton;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool get isPressed => _isPressed;

  bool _isPressed = false;

  void _setIsPressed(bool value) {
    setState(() => _isPressed = value);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    final scaleTween = Tween<double>(begin: 1, end: widget.scaleDownTo);
    final opacityTween = Tween<double>(begin: 1, end: widget.opacityTo);

    _scaleAnimation = scaleTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ),
    );

    _opacityAnimation = opacityTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        _animationController.forward();
        _setIsPressed(true);
      },
      onExit: (_) {
        _animationController.reverse();
        _setIsPressed(false);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (detail) {
          if (widget.vibrateOnPress) HapticFeedback.mediumImpact();
          _animationController.forward();
          _setIsPressed(true);
        },
        onTapUp: (detail) {
          widget.onPressed?.call();
          _animationController.reverse();
          _setIsPressed(false);
        },
        onTapCancel: () {},
        onLongPressDown: (details) {},
        onLongPressEnd: (detail) {},
        onLongPressStart: (detail) {
          widget.onLongPressed?.call();
        },
        onLongPressUp: () {
          widget.onPressed?.call();
          _animationController.reverse();
          _setIsPressed(false);
        },
        onLongPressCancel: () {
          _animationController.reverse();
        },
        onForcePressStart: (detail) {},
        onForcePressEnd: (detail) {},
        onForcePressPeak: (detail) {},
        onForcePressUpdate: (detail) {},
        onTertiaryLongPress: () {},
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: child!,
              ),
            );
          },
          child: Padding(
            padding: widget.margin,
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
