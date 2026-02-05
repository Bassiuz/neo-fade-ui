import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';

/// A glass card with an animated shimmer gradient border.
///
/// This card features a continuously animating gradient border that creates
/// a shimmering effect around the card edges, adding dynamic visual interest.
class NeoCard5 extends StatefulWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? borderWidth;
  final Duration? animationDuration;

  const NeoCard5({
    super.key,
    this.child,
    this.padding,
    this.borderRadius,
    this.borderWidth,
    this.animationDuration,
  });

  @override
  State<NeoCard5> createState() => NeoCard5State();
}

class NeoCard5State extends State<NeoCard5> with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? const Duration(seconds: 3),
    )..repeat();
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
    final effectiveBorderWidth = widget.borderWidth ?? NeoFadeSpacing.xxs;

    final gradientColors = [
      colors.primary,
      colors.secondary,
      colors.tertiary,
      colors.primary,
    ];

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: effectiveBorderRadius,
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.2 + (animationController.value * 0.1)),
                blurRadius: NeoFadeSpacing.sm,
                spreadRadius: 0,
              ),
            ],
          ),
          child: CustomPaint(
            painter: NeoCard5ShimmerBorderPainter(
              colors: gradientColors,
              borderWidth: effectiveBorderWidth,
              borderRadius: effectiveBorderRadius,
              animationValue: animationController.value,
            ),
            child: child,
          ),
        );
      },
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
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the shimmer gradient border of NeoCard5.
class NeoCard5ShimmerBorderPainter extends CustomPainter {
  final List<Color> colors;
  final double borderWidth;
  final BorderRadius borderRadius;
  final double animationValue;

  NeoCard5ShimmerBorderPainter({
    required this.colors,
    required this.borderWidth,
    required this.borderRadius,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (borderWidth <= 0 || colors.isEmpty) return;

    final sweepAngle = 3.14159 * 2;
    final startAngle = animationValue * sweepAngle;

    final gradient = SweepGradient(
      colors: colors,
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      transform: GradientRotation(startAngle),
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
  bool shouldRepaint(NeoCard5ShimmerBorderPainter oldDelegate) {
    return colors != oldDelegate.colors ||
        borderWidth != oldDelegate.borderWidth ||
        borderRadius != oldDelegate.borderRadius ||
        animationValue != oldDelegate.animationValue;
  }
}
