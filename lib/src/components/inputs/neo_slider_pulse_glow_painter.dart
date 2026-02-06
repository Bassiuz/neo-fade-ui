import 'package:flutter/widgets.dart';

/// Custom painter for NeoSliderPulseGlow that draws a slider with
/// gradient glow emanating from the thumb.
class NeoSliderPulseGlowPainter extends CustomPainter {
  final double value;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final double tintOpacity;
  final double borderOpacity;
  final bool isDragging;
  final double pulseIntensity;
  final bool isLight;

  NeoSliderPulseGlowPainter({
    required this.value,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.tintOpacity,
    required this.borderOpacity,
    required this.isDragging,
    required this.pulseIntensity,
    required this.isLight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double trackHeight = 10.0;
    final double thumbRadius = isDragging ? 16.0 : 14.0;
    final double trackY = (size.height - trackHeight) / 2;
    final double trackLeft = thumbRadius;
    final double trackRight = size.width - thumbRadius;
    final double trackWidth = trackRight - trackLeft;
    final double thumbX = trackLeft + trackWidth * value;
    final double thumbY = size.height / 2;

    // Calculate glow radius based on pulse
    final double glowRadius = size.width * 0.4 * pulseIntensity;

    // Radial glow from thumb position
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          primaryColor.withValues(alpha: 0.5 * pulseIntensity),
          secondaryColor.withValues(alpha: 0.3 * pulseIntensity),
          tertiaryColor.withValues(alpha: 0.1 * pulseIntensity),
          surfaceColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.3, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, thumbY), radius: glowRadius))
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      glowPaint,
    );

    // Track background
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight),
      Radius.circular(trackHeight / 2),
    );

    final trackPaint = Paint()
      ..color = surfaceColor.withValues(alpha: tintOpacity * 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(trackRect, trackPaint);

    // Track lit by glow (gradient based on thumb position)
    final litTrackPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment((value * 2 - 1), 0),
        radius: 0.8,
        colors: [
          primaryColor.withValues(alpha: 0.6 * pulseIntensity),
          secondaryColor.withValues(alpha: 0.3 * pulseIntensity),
          tertiaryColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight))
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.clipRRect(trackRect);
    canvas.drawRRect(trackRect, litTrackPaint);
    canvas.restore();

    // Track border
    final trackBorderPaint = Paint()
      ..color = borderColor.withValues(alpha: borderOpacity * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(trackRect, trackBorderPaint);

    // Active track fill (subtle)
    final fillWidth = trackWidth * value;
    if (fillWidth > 0) {
      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(trackLeft, trackY, fillWidth, trackHeight),
        Radius.circular(trackHeight / 2),
      );

      final fillPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            primaryColor.withValues(alpha: 0.8),
            secondaryColor.withValues(alpha: 0.6),
          ],
        ).createShader(Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight))
        ..style = PaintingStyle.fill;
      canvas.drawRRect(fillRect, fillPaint);
    }

    // Outer glow ring
    for (int i = 3; i > 0; i--) {
      final ringRadius = thumbRadius + (i * 8 * pulseIntensity);
      final ringPaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.1 / i * pulseIntensity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(Offset(thumbX, thumbY), ringRadius, ringPaint);
    }

    // Thumb glow
    final thumbGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.8),
          secondaryColor.withValues(alpha: 0.4),
          tertiaryColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, thumbY), radius: thumbRadius * 2))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius * 1.5, thumbGlowPaint);

    // Thumb base
    final thumbBasePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          surfaceColor.withValues(alpha: tintOpacity),
          surfaceColor.withValues(alpha: tintOpacity * 0.8),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, thumbY), radius: thumbRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius, thumbBasePaint);

    // Thumb gradient
    final thumbGradientPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.2),
        colors: [
          primaryColor.withValues(alpha: 0.7),
          secondaryColor.withValues(alpha: 0.5),
          tertiaryColor.withValues(alpha: 0.3),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, thumbY), radius: thumbRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius, thumbGradientPaint);

    // Thumb border
    final thumbBorderPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: borderOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius, thumbBorderPaint);

    // Inner highlight
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.4),
        radius: 0.6,
        colors: [
          const Color(0xFFFFFFFF).withValues(alpha: 0.7),
          const Color(0xFFFFFFFF).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, thumbY), radius: thumbRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius * 0.5, highlightPaint);
  }

  @override
  bool shouldRepaint(NeoSliderPulseGlowPainter oldDelegate) {
    return value != oldDelegate.value ||
        primaryColor != oldDelegate.primaryColor ||
        isDragging != oldDelegate.isDragging ||
        pulseIntensity != oldDelegate.pulseIntensity;
  }
}
