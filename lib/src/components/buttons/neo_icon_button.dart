import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/inner_border.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_button_size.dart';
import 'neo_button_variant.dart';

class NeoIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final NeoButtonVariant variant;
  final NeoButtonSize size;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool enabled;
  final bool loading;
  final String? tooltip;
  final FocusNode? focusNode;
  final bool autofocus;

  const NeoIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.onLongPress,
    this.variant = NeoButtonVariant.ghost,
    this.size = NeoButtonSize.medium,
    this.backgroundColor,
    this.iconColor,
    this.enabled = true,
    this.loading = false,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<NeoIconButton> createState() => NeoIconButtonState();
}

class NeoIconButtonState extends State<NeoIconButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _isHovered = false;
  bool _isFocused = false;

  bool get _isEnabled => widget.enabled && !widget.loading && widget.onPressed != null;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: NeoFadeAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: NeoFadeAnimations.pressedScale).animate(
      CurvedAnimation(parent: _animationController, curve: NeoFadeAnimations.defaultCurve),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get _buttonSize {
    switch (widget.size) {
      case NeoButtonSize.small:
        return 32;
      case NeoButtonSize.medium:
        return 40;
      case NeoButtonSize.large:
        return 48;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case NeoButtonSize.small:
        return 16;
      case NeoButtonSize.medium:
        return 20;
      case NeoButtonSize.large:
        return 24;
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isEnabled) return;
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isEnabled) return;
    _animationController.reverse();
  }

  void _handleTapCancel() {
    if (!_isEnabled) return;
    _animationController.reverse();
  }

  void _handleHoverEnter(PointerEnterEvent event) {
    if (!_isEnabled) return;
    setState(() => _isHovered = true);
  }

  void _handleHoverExit(PointerExitEvent event) {
    setState(() => _isHovered = false);
  }

  void _handleFocusChange(bool focused) {
    setState(() => _isFocused = focused);
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;

    final effectiveOpacity = _isEnabled ? 1.0 : NeoFadeAnimations.disabledOpacity;

    Color backgroundColor;
    Color iconColor;
    double tintOpacity;
    double blur;

    switch (widget.variant) {
      case NeoButtonVariant.filled:
        backgroundColor = widget.backgroundColor ?? colors.primary;
        iconColor = widget.iconColor ?? colors.onPrimary;
        tintOpacity = 0.9;
        blur = 10;
      case NeoButtonVariant.outlined:
        backgroundColor = widget.backgroundColor ?? colors.surface;
        iconColor = widget.iconColor ?? colors.primary;
        tintOpacity = 0.3;
        blur = 15;
      case NeoButtonVariant.ghost:
        backgroundColor = widget.backgroundColor ?? colors.surface;
        iconColor = widget.iconColor ?? colors.onSurface;
        tintOpacity = _isHovered ? 0.2 : 0.1;
        blur = 10;
    }

    final innerBorderOpacity = colors.isLight ? 0.3 : 0.15;
    final innerBorderColor = const Color(0xFFFFFFFF).withValues(alpha: innerBorderOpacity);

    final borderRadius = NeoFadeRadii.fullRadius;

    Widget button = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedOpacity(
            duration: NeoFadeAnimations.fast,
            opacity: effectiveOpacity,
            child: child,
          ),
        );
      },
      child: AnimatedContainer(
        duration: NeoFadeAnimations.normal,
        curve: NeoFadeAnimations.defaultCurve,
        width: _buttonSize,
        height: _buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: _isFocused
              ? Border.all(color: colors.borderFocus, width: 2)
              : widget.variant == NeoButtonVariant.outlined
                  ? Border.all(color: colors.primary, width: 1.5)
                  : null,
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: AnimatedContainer(
              duration: NeoFadeAnimations.normal,
              curve: NeoFadeAnimations.defaultCurve,
              decoration: BoxDecoration(
                color: backgroundColor.withValues(alpha: tintOpacity),
                shape: BoxShape.circle,
              ),
              child: CustomPaint(
                painter: InnerBorderPainter(
                  color: innerBorderColor,
                  width: 1.0,
                  borderRadius: borderRadius,
                ),
                child: Center(
                  child: widget.loading
                      ? SizedBox(
                          width: _iconSize,
                          height: _iconSize,
                          child: _buildLoadingIndicator(iconColor),
                        )
                      : Icon(
                          widget.icon,
                          size: _iconSize,
                          color: iconColor,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    button = Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: _handleFocusChange,
      child: MouseRegion(
        cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: _handleHoverEnter,
        onExit: _handleHoverExit,
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: _isEnabled ? widget.onPressed : null,
          onLongPress: _isEnabled ? widget.onLongPress : null,
          child: button,
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }

  Widget _buildLoadingIndicator(Color color) {
    return _SpinningIndicator(color: color, size: _iconSize);
  }
}

class _SpinningIndicator extends StatefulWidget {
  final Color color;
  final double size;

  const _SpinningIndicator({required this.color, required this.size});

  @override
  State<_SpinningIndicator> createState() => _SpinningIndicatorState();
}

class _SpinningIndicatorState extends State<_SpinningIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 6.28,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _ArcPainter(color: widget.color),
          ),
        );
      },
    );
  }
}

class _ArcPainter extends CustomPainter {
  final Color color;

  _ArcPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 2) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.57,
      2.0,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) => color != oldDelegate.color;
}

class Tooltip extends StatelessWidget {
  final String message;
  final Widget child;

  const Tooltip({
    super.key,
    required this.message,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: message,
      child: child,
    );
  }
}
