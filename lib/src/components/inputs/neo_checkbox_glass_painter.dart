import 'package:flutter/widgets.dart';

/// Custom painter for NeoCheckboxGlass that draws a gradient checkmark.
class NeoCheckboxGlassPainter extends CustomPainter {
  final double progress;
  final List<Color> gradientColors;
  final double strokeWidth;

  NeoCheckboxGlassPainter({
    required this.progress,
    required this.gradientColors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    // Checkmark points relative to size
    final startX = size.width * 0.22;
    final startY = size.height * 0.5;
    final midX = size.width * 0.42;
    final midY = size.height * 0.7;
    final endX = size.width * 0.78;
    final endY = size.height * 0.3;

    path.moveTo(startX, startY);

    // First segment of check (going down)
    final firstSegmentProgress = (progress * 2).clamp(0.0, 1.0);
    if (firstSegmentProgress > 0) {
      path.lineTo(
        startX + (midX - startX) * firstSegmentProgress,
        startY + (midY - startY) * firstSegmentProgress,
      );
    }

    // Second segment of check (going up)
    final secondSegmentProgress = ((progress - 0.5) * 2).clamp(0.0, 1.0);
    if (secondSegmentProgress > 0) {
      path.lineTo(
        midX + (endX - midX) * secondSegmentProgress,
        midY + (endY - midY) * secondSegmentProgress,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(NeoCheckboxGlassPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        gradientColors != oldDelegate.gradientColors ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
