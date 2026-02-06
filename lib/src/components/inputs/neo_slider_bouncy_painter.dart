import 'package:flutter/widgets.dart';

/// Custom painter for NeoSliderBouncy that draws a rounded glass track
/// with a bouncy animated thumb.
class NeoSliderBouncyPainter extends CustomPainter {
  final double value;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final double tintOpacity;
  final double borderOpacity;
  final bool isDragging;
  final double thumbScale;
  final bool isLight;

  NeoSliderBouncyPainter({
    required this.value,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.tintOpacity,
    required this.borderOpacity,
    required this.isDragging,
    required this.thumbScale,
    required this.isLight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double trackHeight = 20.0;
    final double baseThumbRadius = 16.0;
    final double thumbRadius = baseThumbRadius * thumbScale;
    final double trackY = (size.height - trackHeight) / 2;
    final double trackLeft = baseThumbRadius;
    final double trackRight = size.width - baseThumbRadius;
    final double trackWidth = trackRight - trackLeft;

    // Track background (glass effect with rounded ends)
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight),
      Radius.circular(trackHeight / 2),
    );

    // Gradient track background
    final trackGradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          surfaceColor.withValues(alpha: tintOpacity * 0.4),
          surfaceColor.withValues(alpha: tintOpacity * 0.6),
        ],
      ).createShader(Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight))
      ..style = PaintingStyle.fill;
    canvas.drawRRect(trackRect, trackGradientPaint);

    // Active portion with vibrant gradient
    final fillWidth = trackWidth * value;
    if (fillWidth > 0) {
      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(trackLeft, trackY, fillWidth, trackHeight),
        Radius.circular(trackHeight / 2),
      );

      final gradientPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
            tertiaryColor,
          ],
        ).createShader(Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight))
        ..style = PaintingStyle.fill;
      canvas.drawRRect(fillRect, gradientPaint);

      // Shine on active portion
      final shineRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(trackLeft, trackY, fillWidth, trackHeight / 2),
        Radius.circular(trackHeight / 2),
      );
      final shinePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFFFFFF).withValues(alpha: 0.3),
            const Color(0xFFFFFFFF).withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(trackLeft, trackY, fillWidth, trackHeight / 2))
        ..style = PaintingStyle.fill;
      canvas.drawRRect(shineRect, shinePaint);
    }

    // Track border
    final trackBorderPaint = Paint()
      ..color = borderColor.withValues(alpha: borderOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(trackRect, trackBorderPaint);

    // Inner light border
    final innerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(trackLeft + 1, trackY + 1, trackWidth - 2, trackHeight - 2),
      Radius.circular((trackHeight - 2) / 2),
    );
    final innerBorderPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawRRect(innerRect, innerBorderPaint);

    // Thumb position
    final thumbX = trackLeft + trackWidth * value;
    final thumbY = size.height / 2;

    // Thumb shadow (more prominent when bouncing)
    final shadowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.4 * thumbScale)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 * thumbScale);
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius, shadowPaint);

    // Thumb background
    final thumbBgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          surfaceColor.withValues(alpha: tintOpacity),
          surfaceColor.withValues(alpha: tintOpacity * 0.8),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, thumbY), radius: thumbRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius, thumbBgPaint);

    // Thumb gradient overlay
    final thumbGradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryColor.withValues(alpha: 0.6),
          secondaryColor.withValues(alpha: 0.4),
          tertiaryColor.withValues(alpha: 0.3),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, thumbY), radius: thumbRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius, thumbGradientPaint);

    // Thumb border
    final thumbBorderPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: borderOpacity * 1.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius, thumbBorderPaint);

    // Thumb highlight
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 0.7,
        colors: [
          const Color(0xFFFFFFFF).withValues(alpha: 0.6),
          const Color(0xFFFFFFFF).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, thumbY), radius: thumbRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius * 0.6, highlightPaint);
  }

  @override
  bool shouldRepaint(NeoSliderBouncyPainter oldDelegate) {
    return value != oldDelegate.value ||
        primaryColor != oldDelegate.primaryColor ||
        isDragging != oldDelegate.isDragging ||
        thumbScale != oldDelegate.thumbScale;
  }
}
