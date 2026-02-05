import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../foundation/inner_border.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';

/// A glass card with a diagonal gradient stripe across.
///
/// This card features a vibrant diagonal gradient stripe that cuts across
/// the card from corner to corner, creating a bold and dynamic visual effect.
class NeoCard7 extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? stripeWidth;

  const NeoCard7({
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
              painter: NeoCard7DiagonalStripePainter(
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

/// Custom painter for the diagonal gradient stripe of NeoCard7.
class NeoCard7DiagonalStripePainter extends CustomPainter {
  final List<Color> colors;
  final double stripeWidth;

  NeoCard7DiagonalStripePainter({
    required this.colors,
    required this.stripeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    final halfStripe = stripeWidth / 2;
    final centerX = size.width / 2;

    final path = Path()
      ..moveTo(centerX - halfStripe - size.height, 0)
      ..lineTo(centerX + halfStripe - size.height, 0)
      ..lineTo(centerX + halfStripe + size.width, size.height)
      ..lineTo(centerX - halfStripe + size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(NeoCard7DiagonalStripePainter oldDelegate) {
    return colors != oldDelegate.colors || stripeWidth != oldDelegate.stripeWidth;
  }
}
