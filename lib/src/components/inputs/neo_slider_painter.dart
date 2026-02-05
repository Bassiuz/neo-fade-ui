import 'package:flutter/widgets.dart';

/// Custom painter for NeoSlider that draws the thin track with gradient
/// active portion and a subtle thumb with glow.
class NeoSliderPainter extends CustomPainter {
  final double value;
  final Color primaryColor;
  final Color secondaryColor;
  final Color borderColor;
  final bool isDragging;
  final double trackHeight;
  final double thumbSize;
  final Color? inactiveTrackColor;

  NeoSliderPainter({
    required this.value,
    required this.primaryColor,
    required this.secondaryColor,
    required this.borderColor,
    required this.isDragging,
    this.trackHeight = 3.0,
    this.thumbSize = 8.0,
    this.inactiveTrackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double effectiveTrackHeight = trackHeight;
    final double thumbRadius = isDragging ? thumbSize + 2.0 : thumbSize;
    final double trackY = (size.height - effectiveTrackHeight) / 2;
    final double trackLeft = thumbRadius;
    final double trackRight = size.width - thumbRadius;
    final double trackWidth = trackRight - trackLeft;

    // Track background (thin, subtle)
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(trackLeft, trackY, trackWidth, effectiveTrackHeight),
      Radius.circular(effectiveTrackHeight / 2),
    );

    final effectiveInactiveColor = inactiveTrackColor ?? borderColor.withValues(alpha: 0.3);
    final trackPaint = Paint()
      ..color = effectiveInactiveColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(trackRect, trackPaint);

    // Active track with gradient fill
    final fillWidth = trackWidth * value;
    if (fillWidth > 0) {
      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(trackLeft, trackY, fillWidth, effectiveTrackHeight),
        Radius.circular(effectiveTrackHeight / 2),
      );

      final gradientPaint = Paint()
        ..shader = LinearGradient(
          colors: [primaryColor, secondaryColor],
        ).createShader(Rect.fromLTWH(trackLeft, trackY, trackWidth, effectiveTrackHeight))
        ..style = PaintingStyle.fill;
      canvas.drawRRect(fillRect, gradientPaint);
    }

    // Thumb position
    final thumbX = trackLeft + trackWidth * value;
    final thumbY = size.height / 2;

    // Soft glow behind thumb
    final glowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius + 2, glowPaint);

    // Thumb fill (white)
    final thumbFillPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius, thumbFillPaint);

    // Thumb border (primary color)
    final thumbBorderPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius, thumbBorderPaint);
  }

  @override
  bool shouldRepaint(NeoSliderPainter oldDelegate) {
    return value != oldDelegate.value ||
        primaryColor != oldDelegate.primaryColor ||
        secondaryColor != oldDelegate.secondaryColor ||
        borderColor != oldDelegate.borderColor ||
        isDragging != oldDelegate.isDragging ||
        trackHeight != oldDelegate.trackHeight ||
        thumbSize != oldDelegate.thumbSize ||
        inactiveTrackColor != oldDelegate.inactiveTrackColor;
  }
}
