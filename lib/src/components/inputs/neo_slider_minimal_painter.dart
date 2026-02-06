import 'package:flutter/widgets.dart';

/// Custom painter for NeoSliderMinimal that draws a minimal slider
/// with just the gradient active portion.
class NeoSliderMinimalPainter extends CustomPainter {
  final double value;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final bool isDragging;

  NeoSliderMinimalPainter({
    required this.value,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.isDragging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double trackHeight = isDragging ? 8.0 : 6.0;
    final double padding = 8.0;
    final double trackY = (size.height - trackHeight) / 2;
    final double trackLeft = padding;
    final double trackRight = size.width - padding;
    final double trackWidth = trackRight - trackLeft;

    // Background track line (very subtle)
    final bgTrackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight),
      Radius.circular(trackHeight / 2),
    );

    final bgPaint = Paint()
      ..color = surfaceColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(bgTrackRect, bgPaint);

    // Subtle border on background
    final bgBorderPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawRRect(bgTrackRect, bgBorderPaint);

    // Active portion with gradient
    final activeWidth = trackWidth * value;
    if (activeWidth > 0) {
      final activeRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(trackLeft, trackY, activeWidth, trackHeight),
        Radius.circular(trackHeight / 2),
      );

      // Main gradient fill
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
            tertiaryColor,
          ],
        ).createShader(Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight))
        ..style = PaintingStyle.fill;
      canvas.drawRRect(activeRect, gradientPaint);

      // Subtle glow under active portion
      final glowPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            primaryColor.withValues(alpha: 0.3),
            secondaryColor.withValues(alpha: 0.2),
            tertiaryColor.withValues(alpha: 0.1),
          ],
        ).createShader(Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawRRect(activeRect, glowPaint);

      // Top shine
      final shineRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(trackLeft, trackY, activeWidth, trackHeight / 2),
        Radius.circular(trackHeight / 2),
      );
      final shinePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFFFFFF).withValues(alpha: 0.4),
            const Color(0xFFFFFFFF).withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(trackLeft, trackY, activeWidth, trackHeight / 2))
        ..style = PaintingStyle.fill;
      canvas.drawRRect(shineRect, shinePaint);

      // End cap indicator (small circle at the end)
      if (isDragging) {
        final endX = trackLeft + activeWidth;
        final endIndicatorPaint = Paint()
          ..color = const Color(0xFFFFFFFF)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(endX, size.height / 2), trackHeight / 2 + 2, endIndicatorPaint);

        // Gradient overlay on end cap
        final endGradientPaint = Paint()
          ..shader = RadialGradient(
            colors: [
              primaryColor,
              secondaryColor,
            ],
          ).createShader(Rect.fromCircle(center: Offset(endX, size.height / 2), radius: trackHeight / 2 + 2))
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(endX, size.height / 2), trackHeight / 2 + 1, endGradientPaint);
      }
    }
  }

  @override
  bool shouldRepaint(NeoSliderMinimalPainter oldDelegate) {
    return value != oldDelegate.value ||
        primaryColor != oldDelegate.primaryColor ||
        isDragging != oldDelegate.isDragging;
  }
}
