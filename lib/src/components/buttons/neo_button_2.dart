import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Outlined button with gradient border.
class NeoButton2 extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  /// Optional padding inside the button. Defaults to horizontal: lg, vertical: sm.
  final EdgeInsetsGeometry? padding;

  /// Optional border radius. Defaults to NeoFadeRadii.md.
  final double? borderRadius;

  /// Optional border width. Defaults to 2.
  final double? borderWidth;

  /// Optional text style. Color defaults to onSurface if not specified.
  final TextStyle? textStyle;

  /// Optional icon size. Defaults to 18.
  final double? iconSize;

  const NeoButton2({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.padding,
    this.borderRadius,
    this.borderWidth,
    this.textStyle,
    this.iconSize,
  });

  @override
  State<NeoButton2> createState() => NeoButton2State();
}

class NeoButton2State extends State<NeoButton2> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
    final glass = theme.glass;

    final effectivePadding = widget.padding ??
        const EdgeInsets.symmetric(
          horizontal: NeoFadeSpacing.lg,
          vertical: NeoFadeSpacing.sm,
        );
    final effectiveBorderRadius = widget.borderRadius ?? NeoFadeRadii.md;
    final effectiveBorderWidth = widget.borderWidth ?? 2.0;
    final effectiveIconSize = widget.iconSize ?? 18.0;
    final effectiveTextStyle = widget.textStyle ??
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
        );

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.03),
            child: child,
          );
        },
        child: Container(
          padding: EdgeInsets.all(effectiveBorderWidth),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.primary, colors.secondary, colors.tertiary],
            ),
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(effectiveBorderRadius - effectiveBorderWidth),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
              child: Container(
                padding: effectivePadding,
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: glass.tintOpacity),
                  borderRadius: BorderRadius.circular(effectiveBorderRadius - effectiveBorderWidth),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: effectiveIconSize, color: colors.primary),
                      const SizedBox(width: NeoFadeSpacing.xs),
                    ],
                    Text(
                      widget.label,
                      style: effectiveTextStyle.copyWith(
                        color: effectiveTextStyle.color ?? colors.onSurface,
                      ),
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
}
