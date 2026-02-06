import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Custom painter for NeoCheckboxSweep that draws a pie-slice sweep animation with checkmark.
class NeoCheckboxSweepPainter extends CustomPainter {
  final double sweepProgress;
  final double checkProgress;
  final List<Color> gradientColors;
  final Color checkColor;

  NeoCheckboxSweepPainter({
    required this.sweepProgress,
    required this.checkProgress,
    required this.gradientColors,
    required this.checkColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);

    // Draw animated gradient sweep
    if (sweepProgress > 0) {
      canvas.save();

      // Clip to rounded rect
      final clipPath = Path()
        ..addRRect(RRect.fromRectAndRadius(rect.deflate(1), const Radius.circular(5)));
      canvas.clipPath(clipPath);

      // Create sweep gradient that rotates and fills
      final sweepAngle = sweepProgress * 2 * math.pi;

      // For the fill effect: we draw a pie that expands
      final fillPaint = Paint()
        ..shader = SweepGradient(
          center: Alignment.center,
          startAngle: -math.pi / 2,
          endAngle: 3 * math.pi / 2,
          colors: [...gradientColors, gradientColors.first],
          transform: GradientRotation(-math.pi / 2 + sweepAngle * 0.3),
        ).createShader(rect);

      // Draw expanding pie slice
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: size.width),
          -math.pi / 2,
          sweepAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, fillPaint);
      canvas.restore();
    }

    // Draw checkmark
    if (checkProgress > 0) {
      final checkPaint = Paint()
        ..color = checkColor.withValues(alpha: checkProgress)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = Path();

      final startX = size.width * 0.22;
      final startY = size.height * 0.5;
      final midX = size.width * 0.42;
      final midY = size.height * 0.7;
      final endX = size.width * 0.78;
      final endY = size.height * 0.3;

      path.moveTo(startX, startY);

      final firstSegmentProgress = (checkProgress * 2).clamp(0.0, 1.0);
      if (firstSegmentProgress > 0) {
        path.lineTo(
          startX + (midX - startX) * firstSegmentProgress,
          startY + (midY - startY) * firstSegmentProgress,
        );
      }

      final secondSegmentProgress = ((checkProgress - 0.5) * 2).clamp(0.0, 1.0);
      if (secondSegmentProgress > 0) {
        path.lineTo(
          midX + (endX - midX) * secondSegmentProgress,
          midY + (endY - midY) * secondSegmentProgress,
        );
      }

      canvas.drawPath(path, checkPaint);
    }
  }

  @override
  bool shouldRepaint(NeoCheckboxSweepPainter oldDelegate) {
    return sweepProgress != oldDelegate.sweepProgress ||
        checkProgress != oldDelegate.checkProgress ||
        gradientColors != oldDelegate.gradientColors ||
        checkColor != oldDelegate.checkColor;
  }
}
