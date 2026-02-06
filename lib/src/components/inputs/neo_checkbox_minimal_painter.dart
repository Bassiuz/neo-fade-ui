import 'package:flutter/widgets.dart';

/// Custom painter for NeoCheckboxMinimal that draws only a gradient checkmark.
class NeoCheckboxMinimalPainter extends CustomPainter {
  final double checkProgress;
  final double opacity;
  final List<Color> gradientColors;

  NeoCheckboxMinimalPainter({
    required this.checkProgress,
    required this.opacity,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (checkProgress <= 0) return;

    final checkPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    // Larger checkmark for minimal style
    final startX = size.width * 0.18;
    final startY = size.height * 0.5;
    final midX = size.width * 0.4;
    final midY = size.height * 0.75;
    final endX = size.width * 0.82;
    final endY = size.height * 0.25;

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

    // Apply opacity
    canvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Color.fromRGBO(0, 0, 0, opacity),
    );
    canvas.drawPath(path, checkPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(NeoCheckboxMinimalPainter oldDelegate) {
    return checkProgress != oldDelegate.checkProgress ||
        opacity != oldDelegate.opacity ||
        gradientColors != oldDelegate.gradientColors;
  }
}
