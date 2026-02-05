import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';

/// A glass card with a glowing gradient outline.
///
/// This card features a vibrant gradient border that wraps around the entire
/// card with a subtle glow effect, creating a striking visual impact.
class NeoCard2 extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? borderWidth;

  const NeoCard2({
    super.key,
    this.child,
    this.padding,
    this.borderRadius,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final effectivePadding = padding ?? const EdgeInsets.all(NeoFadeSpacing.cardPadding);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(NeoFadeRadii.card);
    final effectiveBorderWidth = borderWidth ?? NeoFadeSpacing.xxs;

    final gradientColors = [
      colors.primary,
      colors.secondary,
      colors.tertiary,
      colors.primary,
    ];

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
        painter: NeoCard2GradientBorderPainter(
          colors: gradientColors,
          borderWidth: effectiveBorderWidth,
          borderRadius: effectiveBorderRadius,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular((effectiveBorderRadius.topLeft.x - effectiveBorderWidth).clamp(0, double.infinity)),
            topRight: Radius.circular((effectiveBorderRadius.topRight.x - effectiveBorderWidth).clamp(0, double.infinity)),
            bottomLeft: Radius.circular((effectiveBorderRadius.bottomLeft.x - effectiveBorderWidth).clamp(0, double.infinity)),
            bottomRight: Radius.circular((effectiveBorderRadius.bottomRight.x - effectiveBorderWidth).clamp(0, double.infinity)),
          ),
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular((effectiveBorderRadius.topLeft.x - effectiveBorderWidth).clamp(0, double.infinity)),
                  topRight: Radius.circular((effectiveBorderRadius.topRight.x - effectiveBorderWidth).clamp(0, double.infinity)),
                  bottomLeft: Radius.circular((effectiveBorderRadius.bottomLeft.x - effectiveBorderWidth).clamp(0, double.infinity)),
                  bottomRight: Radius.circular((effectiveBorderRadius.bottomRight.x - effectiveBorderWidth).clamp(0, double.infinity)),
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the gradient border of NeoCard2.
class NeoCard2GradientBorderPainter extends CustomPainter {
  final List<Color> colors;
  final double borderWidth;
  final BorderRadius borderRadius;

  NeoCard2GradientBorderPainter({
    required this.colors,
    required this.borderWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (borderWidth <= 0 || colors.isEmpty) return;

    final gradient = SweepGradient(
      colors: colors,
      startAngle: 0,
      endAngle: 3.14159 * 2,
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    final outerRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );
    final innerRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        borderWidth,
        borderWidth,
        size.width - borderWidth * 2,
        size.height - borderWidth * 2,
      ),
      topLeft: Radius.circular((borderRadius.topLeft.x - borderWidth).clamp(0, double.infinity)),
      topRight: Radius.circular((borderRadius.topRight.x - borderWidth).clamp(0, double.infinity)),
      bottomLeft: Radius.circular((borderRadius.bottomLeft.x - borderWidth).clamp(0, double.infinity)),
      bottomRight: Radius.circular((borderRadius.bottomRight.x - borderWidth).clamp(0, double.infinity)),
    );

    final path = Path()
      ..addRRect(outerRect)
      ..addRRect(innerRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(NeoCard2GradientBorderPainter oldDelegate) {
    return colors != oldDelegate.colors ||
        borderWidth != oldDelegate.borderWidth ||
        borderRadius != oldDelegate.borderRadius;
  }
}
