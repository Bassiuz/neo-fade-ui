import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../foundation/inner_border.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';

/// A glass card with a corner gradient accent (top-right splash).
///
/// This card features a vibrant gradient splash in the top-right corner,
/// creating a dynamic and eye-catching visual effect while maintaining
/// the glass aesthetic.
class NeoCard4 extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? splashSize;

  const NeoCard4({
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
              painter: NeoCard4CornerSplashPainter(
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

/// Custom painter for the corner gradient splash of NeoCard4.
class NeoCard4CornerSplashPainter extends CustomPainter {
  final List<Color> colors;
  final double splashSize;
  final BorderRadius borderRadius;

  NeoCard4CornerSplashPainter({
    required this.colors,
    required this.splashSize,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = RadialGradient(
      center: Alignment.topRight,
      radius: 1.0,
      colors: colors,
      stops: const [0.0, 0.3, 0.6, 1.0],
    );

    final rect = Rect.fromLTWH(
      size.width - splashSize,
      -splashSize * 0.3,
      splashSize * 1.3,
      splashSize * 1.3,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(NeoCard4CornerSplashPainter oldDelegate) {
    return colors != oldDelegate.colors ||
        splashSize != oldDelegate.splashSize ||
        borderRadius != oldDelegate.borderRadius;
  }
}
