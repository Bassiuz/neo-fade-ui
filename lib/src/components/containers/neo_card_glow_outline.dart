import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_card_glow_outline_painter.dart';

/// A glass card with a glowing gradient outline.
///
/// This card features a vibrant gradient border that wraps around the entire
/// card with a subtle glow effect, creating a striking visual impact.
///
/// When [animated] is true, the gradient border animates with a shimmer effect.
class NeoCardGlowOutline extends StatefulWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? borderWidth;

  /// Whether the gradient border should animate.
  final bool animated;

  /// Animation duration when [animated] is true. Defaults to 3 seconds.
  final Duration? animationDuration;

  const NeoCardGlowOutline({
    super.key,
    this.child,
    this.padding,
    this.borderRadius,
    this.borderWidth,
    this.animated = false,
    this.animationDuration,
  });

  @override
  State<NeoCardGlowOutline> createState() => NeoCardGlowOutlineState();
}

class NeoCardGlowOutlineState extends State<NeoCardGlowOutline> with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    if (widget.animated) {
      animationController = AnimationController(
        vsync: this,
        duration: widget.animationDuration ?? const Duration(seconds: 3),
      )..repeat();
    }
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final effectivePadding = widget.padding ?? const EdgeInsets.all(NeoFadeSpacing.cardPadding);
    final effectiveBorderRadius = widget.borderRadius ?? BorderRadius.circular(NeoFadeRadii.card);
    final effectiveBorderWidth = widget.borderWidth ?? NeoFadeSpacing.xxs;

    final gradientColors = [
      colors.primary,
      colors.secondary,
      colors.tertiary,
      colors.primary,
    ];

    final innerBorderRadius = BorderRadius.only(
      topLeft: Radius.circular((effectiveBorderRadius.topLeft.x - effectiveBorderWidth).clamp(0, double.infinity)),
      topRight: Radius.circular((effectiveBorderRadius.topRight.x - effectiveBorderWidth).clamp(0, double.infinity)),
      bottomLeft: Radius.circular((effectiveBorderRadius.bottomLeft.x - effectiveBorderWidth).clamp(0, double.infinity)),
      bottomRight: Radius.circular((effectiveBorderRadius.bottomRight.x - effectiveBorderWidth).clamp(0, double.infinity)),
    );

    final cardContent = ClipRRect(
      borderRadius: innerBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: glass.blur,
          sigmaY: glass.blur,
        ),
        child: Container(
          margin: EdgeInsets.all(effectiveBorderWidth),
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: glass.tintOpacity),
            borderRadius: innerBorderRadius,
          ),
          child: widget.child,
        ),
      ),
    );

    if (widget.animated && animationController != null) {
      return AnimatedBuilder(
        animation: animationController!,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: effectiveBorderRadius,
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.2 + (animationController!.value * 0.1)),
                  blurRadius: NeoFadeSpacing.sm,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: CustomPaint(
              painter: NeoCardGlowOutlinePainter(
                colors: gradientColors,
                borderWidth: effectiveBorderWidth,
                borderRadius: effectiveBorderRadius,
                animationValue: animationController!.value,
              ),
              child: child,
            ),
          );
        },
        child: cardContent,
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.3),
            blurRadius: NeoFadeSpacing.sm,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: colors.secondary.withValues(alpha: 0.2),
            blurRadius: NeoFadeSpacing.md,
            spreadRadius: 0,
          ),
        ],
      ),
      child: CustomPaint(
        painter: NeoCardGlowOutlinePainter(
          colors: gradientColors,
          borderWidth: effectiveBorderWidth,
          borderRadius: effectiveBorderRadius,
        ),
        child: cardContent,
      ),
    );
  }
}
