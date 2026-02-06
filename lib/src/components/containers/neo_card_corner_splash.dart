import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../foundation/inner_border.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_card_corner_splash_painter.dart';

/// A glass card with a corner gradient accent (top-right splash).
///
/// This card features a vibrant gradient splash in the top-right corner,
/// creating a dynamic and eye-catching visual effect while maintaining
/// the glass aesthetic.
class NeoCardCornerSplash extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? splashSize;

  const NeoCardCornerSplash({
    super.key,
    this.child,
    this.padding,
    this.borderRadius,
    this.splashSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final effectivePadding = padding ?? const EdgeInsets.all(NeoFadeSpacing.cardPadding);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(NeoFadeRadii.card);
    final effectiveSplashSize = splashSize ?? NeoFadeSpacing.xxxl * 2;

    return ClipRRect(
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
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: glass.tintOpacity),
              borderRadius: effectiveBorderRadius,
            ),
            child: CustomPaint(
              painter: NeoCardCornerSplashPainter(
                colors: [
                  colors.primary.withValues(alpha: 0.6),
                  colors.secondary.withValues(alpha: 0.4),
                  colors.tertiary.withValues(alpha: 0.2),
                  colors.surface.withValues(alpha: 0.0),
                ],
                splashSize: effectiveSplashSize,
                borderRadius: effectiveBorderRadius,
              ),
              child: Padding(
                padding: effectivePadding,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
