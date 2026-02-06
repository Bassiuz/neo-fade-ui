import 'package:flutter/widgets.dart';

/// Custom painter for the diagonal gradient stripe of NeoCardDiagonalStripe.
class NeoCardDiagonalStripePainter extends CustomPainter {
  final List<Color> colors;
  final double stripeWidth;

  NeoCardDiagonalStripePainter({
    required this.colors,
    required this.stripeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    final halfStripe = stripeWidth / 2;
    final centerX = size.width / 2;

    final path = Path()
      ..moveTo(centerX - halfStripe - size.height, 0)
      ..lineTo(centerX + halfStripe - size.height, 0)
      ..lineTo(centerX + halfStripe + size.width, size.height)
      ..lineTo(centerX - halfStripe + size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(NeoCardDiagonalStripePainter oldDelegate) {
    return colors != oldDelegate.colors || stripeWidth != oldDelegate.stripeWidth;
  }
}
