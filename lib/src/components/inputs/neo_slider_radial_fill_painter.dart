import 'package:flutter/widgets.dart';

/// Custom painter for NeoSliderRadialFill that draws the glass track
/// with gradient that follows thumb position.
class NeoSliderRadialFillPainter extends CustomPainter {
  final double value;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final double blur;
  final double tintOpacity;
  final double borderOpacity;
  final bool isDragging;
  final bool isLight;

  NeoSliderRadialFillPainter({
    required this.value,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.blur,
    required this.tintOpacity,
    required this.borderOpacity,
    required this.isDragging,
    required this.isLight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double trackHeight = 12.0;
    final double thumbRadius = isDragging ? 14.0 : 12.0;
    final double trackY = (size.height - trackHeight) / 2;
    final double trackLeft = thumbRadius;
    final double trackRight = size.width - thumbRadius;
    final double trackWidth = trackRight - trackLeft;

    // Track background (glass effect)
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight),
      Radius.circular(trackHeight / 2),
    );

    final trackPaint = Paint()
      ..color = surfaceColor.withValues(alpha: tintOpacity * 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(trackRect, trackPaint);

    // Gradient fill that follows thumb
    final thumbX = trackLeft + trackWidth * value;
    final gradientCenter = Alignment(value * 2 - 1, 0);

    final fillRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight),
      Radius.circular(trackHeight / 2),
    );

    // Radial gradient centered on thumb position
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        center: gradientCenter,
        radius: 1.5,
        colors: [
          primaryColor.withValues(alpha: 0.9),
          secondaryColor.withValues(alpha: 0.6),
          tertiaryColor.withValues(alpha: 0.3),
          surfaceColor.withValues(alpha: 0.1),
        ],
        stops: const [0.0, 0.3, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight))
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.clipRRect(fillRect);
    canvas.drawRRect(fillRect, gradientPaint);
    canvas.restore();

    // Track border
    final trackBorderPaint = Paint()
      ..color = borderColor.withValues(alpha: borderOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(trackRect, trackBorderPaint);

    // Inner light border
    final innerBorderRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(trackLeft + 1, trackY + 1, trackWidth - 2, trackHeight - 2),
      Radius.circular((trackHeight - 2) / 2),
    );
    final innerBorderPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawRRect(innerBorderRect, innerBorderPaint);

    // Thumb shadow
    final shadowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(thumbX, size.height / 2), thumbRadius * 0.9, shadowPaint);

    // Thumb glass background
    final thumbPaint = Paint()
      ..color = surfaceColor.withValues(alpha: tintOpacity * 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, size.height / 2), thumbRadius, thumbPaint);

    // Thumb gradient overlay
    final thumbGradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryColor.withValues(alpha: 0.5),
          secondaryColor.withValues(alpha: 0.3),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, size.height / 2), radius: thumbRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, size.height / 2), thumbRadius, thumbGradientPaint);

    // Thumb border
    final thumbBorderPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: borderOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(thumbX, size.height / 2), thumbRadius, thumbBorderPaint);

    // Thumb highlight
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.4),
        radius: 0.8,
        colors: [
          const Color(0xFFFFFFFF).withValues(alpha: 0.5),
          const Color(0xFFFFFFFF).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, size.height / 2), radius: thumbRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, size.height / 2), thumbRadius * 0.7, highlightPaint);
  }

  @override
  bool shouldRepaint(NeoSliderRadialFillPainter oldDelegate) {
    return value != oldDelegate.value ||
        primaryColor != oldDelegate.primaryColor ||
        isDragging != oldDelegate.isDragging;
  }
}
