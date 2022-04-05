import 'package:cccc/constants/constants.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'outlined_button.dart';
part 'text_button.dart';

/// Creates a customizable and tappable widget that bounces and increase in opacity,
///  similar to Spotify's iOS app.
class Button extends StatefulWidget {
  const Button({
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
    Key? key,
  })  : assert(0 <= scaleDownTo && scaleDownTo <= 1,
            'scaleDownTo has to be between 0 and 1'),
        assert(0 <= opacityTo && opacityTo <= 1,
            'opacityTo has to be between 0 and 1'),
        super(key: key);

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

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool get isPressed => _isPressed;
  String? get _widgetKey => (widget.key as ValueKey?)?.value;

  bool _isPressed = false;

  void _setIsPressed(bool value) {
    setState(() => _isPressed = value);
  }

  void _log(String log) => logger.d('[$_widgetKey] function: $log');

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    final _scaleTween = Tween<double>(begin: 1, end: widget.scaleDownTo);
    final _opacityTween = Tween<double>(begin: 1, end: widget.opacityTo);

    _scaleAnimation = _scaleTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ),
    );

    _opacityAnimation = _opacityTween.animate(
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
    return GestureDetector(
      onTapDown: (detail) {
        _log('onTapDown');

        if (widget.vibrateOnPress) HapticFeedback.mediumImpact();
        _animationController.forward();
        _setIsPressed(true);
      },
      onTapUp: (detail) {
        _log('onTapUp');

        widget.onPressed?.call();
        _animationController.reverse();
        _setIsPressed(false);
      },
      onTapCancel: () {
        _log('onTapCancel');
      },
      onLongPressDown: (details) {
        _log('onLongPressDown');
      },
      onLongPressEnd: (detail) {
        _log('onLongPressEnd');
      },
      onLongPressStart: (detail) {
        _log('onLongPressStart');

        widget.onLongPressed?.call();
      },
      onLongPressUp: () {
        _log('onLongPressUp');

        widget.onPressed?.call();
        _animationController.reverse();
        _setIsPressed(false);
      },
      onLongPressCancel: () {
        _log('onLongPressCancel');

        _animationController.reverse();
      },
      onForcePressStart: (detail) {
        _log('onForcePressStart');
      },
      onForcePressEnd: (detail) {
        _log('onForcePressEnd');
      },
      onForcePressPeak: (detail) {
        _log('onForcePressPeak');
      },
      onForcePressUpdate: (detail) {
        _log('onForcePressUpdate');
      },
      onTertiaryLongPress: () {
        _log('onTertiaryLongPress');
      },
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
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Padding(
            padding: widget.margin,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
