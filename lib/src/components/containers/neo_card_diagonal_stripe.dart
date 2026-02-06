import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../foundation/inner_border.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_card_diagonal_stripe_painter.dart';

/// A glass card with a diagonal gradient stripe across.
///
/// This card features a vibrant diagonal gradient stripe that cuts across
/// the card from corner to corner, creating a bold and dynamic visual effect.
class NeoCardDiagonalStripe extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? stripeWidth;

  const NeoCardDiagonalStripe({
    super.key,
    this.child,
    this.padding,
    this.borderRadius,
    this.stripeWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final effectivePadding = padding ?? const EdgeInsets.all(NeoFadeSpacing.cardPadding);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(NeoFadeRadii.card);
    final effectiveStripeWidth = stripeWidth ?? NeoFadeSpacing.xxxl;

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
              painter: NeoCardDiagonalStripePainter(
                colors: [
                  colors.primary.withValues(alpha: 0.0),
                  colors.primary.withValues(alpha: 0.3),
                  colors.secondary.withValues(alpha: 0.4),
                  colors.tertiary.withValues(alpha: 0.3),
                  colors.tertiary.withValues(alpha: 0.0),
                ],
                stripeWidth: effectiveStripeWidth,
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
