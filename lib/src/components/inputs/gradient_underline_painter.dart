import 'package:flutter/widgets.dart';

/// Custom painter for drawing a gradient underline with animation.
///
/// Draws a base underline with a gradient overlay that expands
/// from the center based on the progress value.
class GradientUnderlinePainter extends CustomPainter {
  final List<Color> gradientColors;
  final Color baseColor;
  final double progress;

  GradientUnderlinePainter({
    required this.gradientColors,
    required this.baseColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      basePaint,
    );

    if (progress > 0) {
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          colors: gradientColors,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;

      final gradientWidth = size.width * progress;
      final startX = (size.width - gradientWidth) / 2;

      canvas.drawRect(
        Rect.fromLTWH(startX, 0, gradientWidth, size.height),
        gradientPaint,
      );
    }
  }

  @override
  bool shouldRepaint(GradientUnderlinePainter oldDelegate) {
    return progress != oldDelegate.progress ||
        baseColor != oldDelegate.baseColor ||
        gradientColors != oldDelegate.gradientColors;
  }
}
