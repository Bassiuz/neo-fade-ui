import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Gradient-filled button with glass effect.
class NeoButton1 extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  /// Optional padding. Defaults to horizontal: lg, vertical: sm.
  final EdgeInsetsGeometry? padding;

  /// Optional border radius. Defaults to NeoFadeRadii.md.
  final double? borderRadius;

  /// Optional text style. Color defaults to onPrimary if not specified.
  final TextStyle? textStyle;

  /// Optional icon size. Defaults to 18.
  final double? iconSize;

  const NeoButton1({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.padding,
    this.borderRadius,
    this.textStyle,
    this.iconSize,
  });

  @override
  State<NeoButton1> createState() => NeoButton1State();
}

class NeoButton1State extends State<NeoButton1> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.fast,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;

    final effectivePadding = widget.padding ??
        const EdgeInsets.symmetric(
          horizontal: NeoFadeSpacing.lg,
          vertical: NeoFadeSpacing.sm,
        );
    final effectiveBorderRadius = widget.borderRadius ?? NeoFadeRadii.md;
    final effectiveIconSize = widget.iconSize ?? 18.0;
    final effectiveTextStyle = widget.textStyle ??
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colors.onPrimary,
        );

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.03),
            child: child,
          );
        },
        child: Container(
          padding: effectivePadding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.primary, colors.secondary],
            ),
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.4),
                blurRadius: NeoFadeSpacing.md,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: effectiveIconSize, color: colors.onPrimary),
                const SizedBox(width: NeoFadeSpacing.xs),
              ],
              Text(
                widget.label,
                style: effectiveTextStyle.copyWith(
                  color: effectiveTextStyle.color ?? colors.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
