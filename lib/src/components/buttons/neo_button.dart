import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/gradient_border.dart';
import '../../foundation/inner_border.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_button_size.dart';
import 'neo_button_style.dart';
import 'neo_button_variant.dart';

class NeoButton extends StatefulWidget {
  final Widget? child;
  final String? label;
  final IconData? icon;
  final IconData? trailingIcon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final NeoButtonVariant variant;
  final NeoButtonSize size;
  final NeoButtonStyle? style;
  final bool enabled;
  final bool loading;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool showGradientBorder;
  final List<Color>? gradientBorderColors;

  const NeoButton({
    super.key,
    this.child,
    this.label,
    this.icon,
    this.trailingIcon,
    this.onPressed,
    this.onLongPress,
    this.variant = NeoButtonVariant.filled,
    this.size = NeoButtonSize.medium,
    this.style,
    this.enabled = true,
    this.loading = false,
    this.focusNode,
    this.autofocus = false,
    this.showGradientBorder = false,
    this.gradientBorderColors,
  });

  @override
  State<NeoButton> createState() => NeoButtonState();
}

class NeoButtonState extends State<NeoButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool _isHovered = false;
  bool _isPressed = false;
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
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: NeoFadeAnimations.defaultCurve),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isEnabled) return;
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isEnabled) return;
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    if (!_isEnabled) return;
    setState(() => _isPressed = false);
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
    final resolvedStyle = NeoButtonStyle.resolveStyle(
      variant: widget.variant,
      size: widget.size,
      colors: colors,
      style: widget.style,
    );

    final effectiveOpacity = _isEnabled ? 1.0 : NeoFadeAnimations.disabledOpacity;
    final hoverOpacityBoost = _isHovered ? NeoFadeAnimations.hoverOpacityIncrease : 0.0;

    final backgroundColor = resolvedStyle.backgroundColor!;
    final foregroundColor = resolvedStyle.foregroundColor!;
    final borderRadius = resolvedStyle.borderRadius!;

    final innerBorderColor = colors.isLight
        ? const Color(0xFFFFFFFF).withValues(alpha: resolvedStyle.innerBorderOpacity!)
        : const Color(0xFFFFFFFF).withValues(alpha: resolvedStyle.innerBorderOpacity!);

    final focusBorderColor = _isFocused ? colors.borderFocus : null;

    final gradientColors = widget.gradientBorderColors ??
        [colors.primary, colors.secondary, colors.tertiary];

    return Focus(
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
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: AnimatedOpacity(
                  duration: NeoFadeAnimations.fast,
                  opacity: effectiveOpacity * _opacityAnimation.value,
                  child: child,
                ),
              );
            },
            child: AnimatedContainer(
              duration: NeoFadeAnimations.normal,
              curve: NeoFadeAnimations.defaultCurve,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: focusBorderColor != null
                    ? Border.all(color: focusBorderColor, width: 2)
                    : resolvedStyle.borderWidth! > 0
                        ? Border.all(
                            color: resolvedStyle.borderColor!,
                            width: resolvedStyle.borderWidth!,
                          )
                        : null,
              ),
              child: ClipRRect(
                borderRadius: borderRadius,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: resolvedStyle.blur!,
                    sigmaY: resolvedStyle.blur!,
                  ),
                  child: widget.showGradientBorder
                      ? GradientBorder(
                          colors: gradientColors,
                          borderWidth: 2,
                          borderRadius: borderRadius,
                          child: AnimatedContainer(
                            duration: NeoFadeAnimations.normal,
                            curve: NeoFadeAnimations.defaultCurve,
                            padding: resolvedStyle.padding,
                            decoration: BoxDecoration(
                              color: backgroundColor.withValues(
                                alpha: (resolvedStyle.tintOpacity! + hoverOpacityBoost).clamp(0.0, 1.0),
                              ),
                              borderRadius: borderRadius,
                            ),
                            child: _buildContent(foregroundColor),
                          ),
                        )
                      : InnerBorder(
                          color: innerBorderColor,
                          width: 1.0,
                          borderRadius: borderRadius,
                          child: AnimatedContainer(
                            duration: NeoFadeAnimations.normal,
                            curve: NeoFadeAnimations.defaultCurve,
                            padding: resolvedStyle.padding,
                            decoration: BoxDecoration(
                              color: backgroundColor.withValues(
                                alpha: (resolvedStyle.tintOpacity! + hoverOpacityBoost).clamp(0.0, 1.0),
                              ),
                              borderRadius: borderRadius,
                            ),
                            child: _buildContent(foregroundColor),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color foregroundColor) {
    final fontSize = NeoButtonStyle.fontSizeForSize(widget.size);
    final textStyle = TextStyle(
      color: foregroundColor,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    );

    if (widget.loading) {
      return SizedBox(
        width: fontSize,
        height: fontSize,
        child: Center(
          child: SizedBox(
            width: fontSize,
            height: fontSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(foregroundColor),
            ),
          ),
        ),
      );
    }

    if (widget.child != null) {
      return DefaultTextStyle(
        style: textStyle,
        child: IconTheme(
          data: IconThemeData(color: foregroundColor, size: fontSize + 4),
          child: widget.child!,
        ),
      );
    }

    final hasIcon = widget.icon != null;
    final hasTrailingIcon = widget.trailingIcon != null;
    final hasLabel = widget.label != null;

    final children = <Widget>[];

    if (hasIcon) {
      children.add(Icon(widget.icon, color: foregroundColor, size: fontSize + 4));
      if (hasLabel) {
        children.add(const SizedBox(width: 8));
      }
    }

    if (hasLabel) {
      children.add(Text(widget.label!, style: textStyle));
    }

    if (hasTrailingIcon) {
      if (hasLabel || hasIcon) {
        children.add(const SizedBox(width: 8));
      }
      children.add(Icon(widget.trailingIcon, color: foregroundColor, size: fontSize + 4));
    }

    if (children.length == 1) {
      return children.first;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

class CircularProgressIndicator extends StatefulWidget {
  final double strokeWidth;
  final Animation<Color?> valueColor;

  const CircularProgressIndicator({
    super.key,
    this.strokeWidth = 4.0,
    required this.valueColor,
  });

  @override
  State<CircularProgressIndicator> createState() => CircularProgressIndicatorState();
}

class CircularProgressIndicatorState extends State<CircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
        return CustomPaint(
          painter: CircularProgressPainter(
            color: widget.valueColor.value ?? const Color(0xFFFFFFFF),
            strokeWidth: widget.strokeWidth,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double progress;

  CircularProgressPainter({
    required this.color,
    required this.strokeWidth,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    const sweepAngle = 2.0;
    final startAngle = progress * 6.28 - 1.57;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        progress != oldDelegate.progress;
  }
}
