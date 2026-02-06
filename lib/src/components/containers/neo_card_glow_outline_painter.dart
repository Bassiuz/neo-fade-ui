import 'package:flutter/widgets.dart';

/// Custom painter for the gradient border of NeoCardGlowOutline.
class NeoCardGlowOutlinePainter extends CustomPainter {
  final List<Color> colors;
  final double borderWidth;
  final BorderRadius borderRadius;
  final double? animationValue;

  NeoCardGlowOutlinePainter({
    required this.colors,
    required this.borderWidth,
    required this.borderRadius,
    this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (borderWidth <= 0 || colors.isEmpty) return;

    final sweepAngle = 3.14159 * 2;
    final startAngle = (animationValue ?? 0) * sweepAngle;

    final Gradient gradient;
    if (animationValue != null) {
      gradient = SweepGradient(
        colors: colors,
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        transform: GradientRotation(startAngle),
      );
    } else {
      gradient = SweepGradient(
        colors: colors,
        startAngle: 0,
        endAngle: sweepAngle,
      );
    }

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    final outerRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );
    final innerRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        borderWidth,
        borderWidth,
        size.width - borderWidth * 2,
        size.height - borderWidth * 2,
      ),
      topLeft: Radius.circular((borderRadius.topLeft.x - borderWidth).clamp(0, double.infinity)),
      topRight: Radius.circular((borderRadius.topRight.x - borderWidth).clamp(0, double.infinity)),
      bottomLeft: Radius.circular((borderRadius.bottomLeft.x - borderWidth).clamp(0, double.infinity)),
      bottomRight: Radius.circular((borderRadius.bottomRight.x - borderWidth).clamp(0, double.infinity)),
    );

    final path = Path()
      ..addRRect(outerRect)
      ..addRRect(innerRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(NeoCardGlowOutlinePainter oldDelegate) {
    return colors != oldDelegate.colors ||
        borderWidth != oldDelegate.borderWidth ||
        borderRadius != oldDelegate.borderRadius ||
        animationValue != oldDelegate.animationValue;
  }
}
