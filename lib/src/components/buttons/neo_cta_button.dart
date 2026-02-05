import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

import '../../foundation/inner_border.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_button_size.dart';
import 'neo_button_style.dart';

class NeoCTAButton extends StatefulWidget {
  final Widget? child;
  final String? label;
  final IconData? icon;
  final IconData? trailingIcon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final NeoButtonSize size;
  final bool enabled;
  final bool loading;
  final bool animated;
  final FocusNode? focusNode;
  final bool autofocus;
  final List<Color>? gradientColors;

  const NeoCTAButton({
    super.key,
    this.child,
    this.label,
    this.icon,
    this.trailingIcon,
    this.onPressed,
    this.onLongPress,
    this.size = NeoButtonSize.medium,
    this.enabled = true,
    this.loading = false,
    this.animated = true,
    this.focusNode,
    this.autofocus = false,
    this.gradientColors,
  });

  @override
  State<NeoCTAButton> createState() => NeoCTAButtonState();
}

class NeoCTAButtonState extends State<NeoCTAButton> with SingleTickerProviderStateMixin {
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

    final gradientColors = widget.gradientColors ??
        [
          colors.primary,
          colors.secondary,
          colors.tertiary,
        ];

    final effectiveOpacity = _isEnabled ? 1.0 : NeoFadeAnimations.disabledOpacity;
    final borderRadius = BorderRadius.circular(
      widget.size == NeoButtonSize.small
          ? 8
          : widget.size == NeoButtonSize.large
              ? 16
              : 12,
    );

    final focusBorderColor = _isFocused ? colors.borderFocus : null;

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
                    : null,
              ),
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: _buildGradientBackground(gradientColors),
                    ),
                    Container(
                      padding: NeoButtonStyle.paddingForSize(widget.size),
                      child: _buildContent(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientBackground(List<Color> gradientColors) {
    final fourColors = _ensureFourColors(gradientColors);

    if (widget.animated) {
      return AnimatedMeshGradient(
        colors: fourColors,
        options: AnimatedMeshGradientOptions(
          speed: 3,
          frequency: 2,
          amplitude: 20,
          grain: 0.2,
        ),
      );
    }

    return MeshGradient(
      points: [
        MeshGradientPoint(position: const Offset(0.1, 0.1), color: fourColors[0]),
        MeshGradientPoint(position: const Offset(0.9, 0.2), color: fourColors[1]),
        MeshGradientPoint(position: const Offset(0.2, 0.8), color: fourColors[2]),
        MeshGradientPoint(position: const Offset(0.8, 0.9), color: fourColors[3]),
      ],
      options: MeshGradientOptions(blend: 3.5, noiseIntensity: 0.3),
    );
  }

  List<Color> _ensureFourColors(List<Color> colors) {
    if (colors.length >= 4) return colors.sublist(0, 4);
    final result = List<Color>.from(colors);
    while (result.length < 4) {
      result.add(colors[result.length % colors.length]);
    }
    return result;
  }

  Widget _buildContent() {
    final fontSize = NeoButtonStyle.fontSizeForSize(widget.size);
    const foregroundColor = Color(0xFFFFFFFF);
    final textStyle = TextStyle(
      color: foregroundColor,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
    );

    if (widget.loading) {
      return SizedBox(
        width: fontSize,
        height: fontSize,
        child: Center(
          child: SizedBox(
            width: fontSize,
            height: fontSize,
            child: CTAProgressIndicator(
              strokeWidth: 2,
              color: foregroundColor,
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
      if (hasLabel) children.add(const SizedBox(width: 8));
    }

    if (hasLabel) {
      children.add(Text(widget.label!, style: textStyle));
    }

    if (hasTrailingIcon) {
      if (hasLabel || hasIcon) children.add(const SizedBox(width: 8));
      children.add(Icon(widget.trailingIcon, color: foregroundColor, size: fontSize + 4));
    }

    if (children.length == 1) return children.first;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

class CTAProgressIndicator extends StatefulWidget {
  final double strokeWidth;
  final Color color;

  const CTAProgressIndicator({
    super.key,
    this.strokeWidth = 4.0,
    required this.color,
  });

  @override
  State<CTAProgressIndicator> createState() => CTAProgressIndicatorState();
}

class CTAProgressIndicatorState extends State<CTAProgressIndicator>
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
          painter: CTAProgressPainter(
            color: widget.color,
            strokeWidth: widget.strokeWidth,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class CTAProgressPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double progress;

  CTAProgressPainter({
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
  bool shouldRepaint(CTAProgressPainter oldDelegate) {
    return color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        progress != oldDelegate.progress;
  }
}
