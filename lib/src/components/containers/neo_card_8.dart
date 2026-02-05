import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../foundation/inner_border.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';

/// A glass card with a pulsing gradient glow shadow.
///
/// This card features an animated pulsing glow effect that creates
/// a vibrant gradient shadow around the card, adding a dynamic and
/// attention-grabbing visual effect.
class NeoCard8 extends StatefulWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Duration? pulseDuration;
  final double? maxGlowRadius;

  const NeoCard8({
    super.key,
    this.child,
    this.padding,
    this.borderRadius,
    this.pulseDuration,
    this.maxGlowRadius,
  });

  @override
  State<NeoCard8> createState() => NeoCard8State();
}

class NeoCard8State extends State<NeoCard8> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> pulseAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.pulseDuration ?? const Duration(seconds: 2),
    )..repeat(reverse: true);

    pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final effectivePadding = widget.padding ?? const EdgeInsets.all(NeoFadeSpacing.cardPadding);
    final effectiveBorderRadius = widget.borderRadius ?? BorderRadius.circular(NeoFadeRadii.card);
    final effectiveMaxGlowRadius = widget.maxGlowRadius ?? NeoFadeSpacing.lg;

    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        final glowIntensity = pulseAnimation.value;
        final blurRadius = effectiveMaxGlowRadius * glowIntensity;

        return Container(
          decoration: BoxDecoration(
            borderRadius: effectiveBorderRadius,
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.4 * glowIntensity),
                blurRadius: blurRadius,
                spreadRadius: NeoFadeSpacing.xxs * glowIntensity,
                offset: Offset(-NeoFadeSpacing.xxs, -NeoFadeSpacing.xxs),
              ),
              BoxShadow(
                color: colors.secondary.withValues(alpha: 0.35 * glowIntensity),
                blurRadius: blurRadius * 0.8,
                spreadRadius: NeoFadeSpacing.xxs * glowIntensity * 0.5,
                offset: Offset(NeoFadeSpacing.xxs, NeoFadeSpacing.xxs),
              ),
              BoxShadow(
                color: colors.tertiary.withValues(alpha: 0.3 * glowIntensity),
                blurRadius: blurRadius * 0.6,
                spreadRadius: 0,
                offset: Offset(0, NeoFadeSpacing.xs * glowIntensity),
              ),
            ],
          ),
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: glass.blur,
            sigmaY: glass.blur,
          ),
          child: InnerBorder(
            color: const Color(0xFFFFFFFF).withValues(alpha: glass.borderOpacity),
            width: glass.innerBorderWidth,
            borderRadius: effectiveBorderRadius,
            child: Container(
              padding: effectivePadding,
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: glass.tintOpacity),
                borderRadius: effectiveBorderRadius,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
