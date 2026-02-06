import 'package:flutter/widgets.dart';

/// Custom painter for NeoCheckboxFillScale that draws a scaling gradient fill with checkmark.
class NeoCheckboxFillScalePainter extends CustomPainter {
  final double fillProgress;
  final double checkProgress;
  final List<Color> gradientColors;
  final Color backgroundColor;
  final Color checkColor;
  final double borderRadius;

  NeoCheckboxFillScalePainter({
    required this.fillProgress,
    required this.checkProgress,
    required this.gradientColors,
    required this.backgroundColor,
    required this.checkColor,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius - 1.5));

    // Draw background
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRRect(rrect, bgPaint);

    // Draw gradient fill
    if (fillProgress > 0) {
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ).createShader(rect);

      canvas.save();
      canvas.clipRRect(rrect);

      // Scale from center
      final scale = fillProgress;
      canvas.translate(size.width / 2, size.height / 2);
      canvas.scale(scale);
      canvas.translate(-size.width / 2, -size.height / 2);

      canvas.drawRRect(rrect, gradientPaint);
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
  bool shouldRepaint(NeoCheckboxFillScalePainter oldDelegate) {
    return fillProgress != oldDelegate.fillProgress ||
        checkProgress != oldDelegate.checkProgress ||
        gradientColors != oldDelegate.gradientColors ||
        backgroundColor != oldDelegate.backgroundColor ||
        checkColor != oldDelegate.checkColor;
  }
}
