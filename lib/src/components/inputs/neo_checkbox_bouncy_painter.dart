import 'package:flutter/widgets.dart';

/// Custom painter for NeoCheckboxBouncy that draws a checkmark with bounce effect.
class NeoCheckboxBouncyPainter extends CustomPainter {
  final double checkProgress;
  final double bounceProgress;
  final Color checkColor;
  final List<Color> gradientColors;

  NeoCheckboxBouncyPainter({
    required this.checkProgress,
    required this.bounceProgress,
    required this.checkColor,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (checkProgress <= 0) return;

    // Use white check when filled, gradient when not
    final checkPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (bounceProgress > 0.5) {
      checkPaint.color = checkColor;
    } else {
      checkPaint.shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    }

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

  @override
  bool shouldRepaint(NeoCheckboxBouncyPainter oldDelegate) {
    return checkProgress != oldDelegate.checkProgress ||
        bounceProgress != oldDelegate.bounceProgress ||
        checkColor != oldDelegate.checkColor ||
        gradientColors != oldDelegate.gradientColors;
  }
}
