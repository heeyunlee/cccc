import 'package:cccc/services/logger_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kHorizontalPadding = 16.0;
const kVerticalPadding = 4.0;

class Button extends StatefulWidget {
  const Button({
    required this.child,
    required this.onPress,
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
  final VoidCallback? onPress;
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
    required VoidCallback? onPress,
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

        widget.onPress?.call();
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
      },
      onLongPressUp: () {
        _log('onLongPressUp');

        widget.onPress?.call();
        _animationController.reverse();
        _setIsPressed(false);
      },
      onLongPressCancel: () {
        _log('onLongPressCancel');

        _animationController.reverse();
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

class _OutlinedButton extends Button {
  _OutlinedButton({
    required Widget child,
    required VoidCallback? onPress,
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
    Key? key,
  }) : super(
          onPress: onPress,
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
          child: _OutlinedButtonChild(
            child: child,
            borderColor: borderColor,
            borderWidth: borderWidth,
            borderRadius: borderRadius,
            padding: padding,
          ),
        );
}

class _OutlinedButtonChild extends StatelessWidget {
  const _OutlinedButtonChild({
    Key? key,
    required this.child,
    required this.padding,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
  }) : super(key: key);

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
        child: child,
      ),
    );
  }
}
