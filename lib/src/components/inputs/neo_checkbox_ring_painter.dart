import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Custom painter for NeoCheckboxRing that draws a sweeping ring and fill circle.
class NeoCheckboxRingPainter extends CustomPainter {
  final double ringProgress;
  final double fillProgress;
  final List<Color> gradientColors;
  final Color borderColor;

  NeoCheckboxRingPainter({
    required this.ringProgress,
    required this.fillProgress,
    required this.gradientColors,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw base border ring
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius - 1, borderPaint);

    // Draw gradient ring (sweeps around)
    if (ringProgress > 0) {
      final ringPaint = Paint()
        ..shader = SweepGradient(
          colors: [...gradientColors, gradientColors.first],
          startAngle: -math.pi / 2,
          endAngle: 3 * math.pi / 2,
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 2),
        -math.pi / 2,
        2 * math.pi * ringProgress,
        false,
        ringPaint,
      );
    }

    // Draw inner fill circle
    if (fillProgress > 0) {
      final fillRadius = (radius - 6) * fillProgress;

      final fillPaint = Paint()
        ..shader = RadialGradient(
          colors: gradientColors,
        ).createShader(Rect.fromCircle(center: center, radius: fillRadius));

      canvas.drawCircle(center, fillRadius, fillPaint);
    }
  }

  @override
  bool shouldRepaint(NeoCheckboxRingPainter oldDelegate) {
    return ringProgress != oldDelegate.ringProgress ||
        fillProgress != oldDelegate.fillProgress ||
        gradientColors != oldDelegate.gradientColors ||
        borderColor != oldDelegate.borderColor;
  }
}
