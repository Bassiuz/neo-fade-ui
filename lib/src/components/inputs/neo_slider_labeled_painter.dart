import 'package:flutter/widgets.dart';

/// Custom painter for NeoSliderLabeled that draws a glass track
/// with a gradient thumb showing the current value.
class NeoSliderLabeledPainter extends CustomPainter {
  final double value;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final Color onSurfaceColor;
  final double tintOpacity;
  final double borderOpacity;
  final bool isDragging;
  final bool isLight;

  NeoSliderLabeledPainter({
    required this.value,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.onSurfaceColor,
    required this.tintOpacity,
    required this.borderOpacity,
    required this.isDragging,
    required this.isLight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double trackHeight = 8.0;
    final double thumbWidth = isDragging ? 48.0 : 44.0;
    final double thumbHeight = isDragging ? 28.0 : 24.0;
    final double trackY = (size.height - trackHeight) / 2;
    final double trackLeft = thumbWidth / 2;
    final double trackRight = size.width - thumbWidth / 2;
    final double trackWidth = trackRight - trackLeft;

    // Track background (glass)
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight),
      Radius.circular(trackHeight / 2),
    );

    final trackPaint = Paint()
      ..color = surfaceColor.withValues(alpha: tintOpacity * 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(trackRect, trackPaint);

    // Track gradient overlay
    final trackGradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          primaryColor.withValues(alpha: 0.1),
          secondaryColor.withValues(alpha: 0.1),
          tertiaryColor.withValues(alpha: 0.1),
        ],
      ).createShader(Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight))
      ..style = PaintingStyle.fill;
    canvas.drawRRect(trackRect, trackGradientPaint);

    // Track border
    final trackBorderPaint = Paint()
      ..color = borderColor.withValues(alpha: borderOpacity * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(trackRect, trackBorderPaint);

    // Active track fill
    final fillWidth = trackWidth * value;
    if (fillWidth > 0) {
      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(trackLeft, trackY, fillWidth, trackHeight),
        Radius.circular(trackHeight / 2),
      );

      final fillPaint = Paint()
        ..shader = LinearGradient(
          colors: [primaryColor, secondaryColor, tertiaryColor],
        ).createShader(Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight))
        ..style = PaintingStyle.fill;
      canvas.drawRRect(fillRect, fillPaint);
    }

    // Thumb position
    final thumbX = trackLeft + trackWidth * value;
    final thumbY = size.height / 2;
    final thumbRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(thumbX, thumbY), width: thumbWidth, height: thumbHeight),
      Radius.circular(thumbHeight / 2),
    );

    // Thumb shadow
    final shadowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRRect(thumbRect, shadowPaint);

    // Thumb background (glass)
    final thumbBgPaint = Paint()
      ..color = surfaceColor.withValues(alpha: tintOpacity * 0.9)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(thumbRect, thumbBgPaint);

    // Thumb gradient fill
    final thumbGradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryColor.withValues(alpha: 0.7),
          secondaryColor.withValues(alpha: 0.5),
          tertiaryColor.withValues(alpha: 0.4),
        ],
      ).createShader(Rect.fromCenter(center: Offset(thumbX, thumbY), width: thumbWidth, height: thumbHeight))
      ..style = PaintingStyle.fill;
    canvas.drawRRect(thumbRect, thumbGradientPaint);

    // Thumb border
    final thumbBorderPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: borderOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(thumbRect, thumbBorderPaint);

    // Thumb highlight
    final highlightRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(thumbX, thumbY - thumbHeight * 0.15), width: thumbWidth * 0.8, height: thumbHeight * 0.4),
      Radius.circular(thumbHeight / 4),
    );
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFFFFFF).withValues(alpha: 0.4),
          const Color(0xFFFFFFFF).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCenter(center: Offset(thumbX, thumbY - thumbHeight * 0.15), width: thumbWidth * 0.8, height: thumbHeight * 0.4))
      ..style = PaintingStyle.fill;
    canvas.drawRRect(highlightRect, highlightPaint);

    // Value text
    final percentage = (value * 100).round();
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$percentage',
        style: TextStyle(
          color: const Color(0xFFFFFFFF),
          fontSize: isDragging ? 11.0 : 10.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(thumbX - textPainter.width / 2, thumbY - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(NeoSliderLabeledPainter oldDelegate) {
    return value != oldDelegate.value ||
        primaryColor != oldDelegate.primaryColor ||
        isDragging != oldDelegate.isDragging ||
        isLight != oldDelegate.isLight;
  }
}
