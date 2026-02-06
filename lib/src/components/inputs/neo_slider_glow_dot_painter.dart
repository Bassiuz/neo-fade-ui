import 'package:flutter/widgets.dart';

/// Custom painter for NeoSliderGlowDot that draws a thin gradient line track
/// with a glowing dot thumb.
class NeoSliderGlowDotPainter extends CustomPainter {
  final double value;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color surfaceColor;
  final bool isDragging;
  final double glowIntensity;

  NeoSliderGlowDotPainter({
    required this.value,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.surfaceColor,
    required this.isDragging,
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double trackHeight = 3.0;
    final double thumbRadius = isDragging ? 10.0 : 8.0;
    final double padding = 16.0;
    final double trackY = size.height / 2;
    final double trackLeft = padding;
    final double trackRight = size.width - padding;
    final double trackWidth = trackRight - trackLeft;

    // Inactive track (subtle)
    final inactiveTrackPaint = Paint()
      ..color = surfaceColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackHeight
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(trackLeft, trackY),
      Offset(trackRight, trackY),
      inactiveTrackPaint,
    );

    // Active gradient track
    final activeWidth = trackWidth * value;
    if (activeWidth > 0) {
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          colors: [primaryColor, secondaryColor, tertiaryColor],
        ).createShader(Rect.fromLTWH(trackLeft, trackY - trackHeight / 2, trackWidth, trackHeight))
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackHeight
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(trackLeft, trackY),
        Offset(trackLeft + activeWidth, trackY),
        gradientPaint,
      );
    }

    // Thumb position
    final thumbX = trackLeft + trackWidth * value;

    // Outer glow
    final outerGlowRadius = thumbRadius * 3 * glowIntensity;
    final outerGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.4 * glowIntensity),
          secondaryColor.withValues(alpha: 0.2 * glowIntensity),
          tertiaryColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, trackY), radius: outerGlowRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, trackY), outerGlowRadius, outerGlowPaint);

    // Inner glow
    final innerGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.8),
          secondaryColor.withValues(alpha: 0.4),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, trackY), radius: thumbRadius * 1.5))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(thumbX, trackY), thumbRadius * 1.5, innerGlowPaint);

    // Solid thumb center
    final thumbPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFFFFF),
          primaryColor,
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, trackY), radius: thumbRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, trackY), thumbRadius, thumbPaint);
  }

  @override
  bool shouldRepaint(NeoSliderGlowDotPainter oldDelegate) {
    return value != oldDelegate.value ||
        primaryColor != oldDelegate.primaryColor ||
        isDragging != oldDelegate.isDragging ||
        glowIntensity != oldDelegate.glowIntensity;
  }
}
