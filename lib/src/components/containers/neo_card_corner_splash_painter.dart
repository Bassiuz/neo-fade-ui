import 'package:flutter/widgets.dart';

/// Custom painter for the corner gradient splash of NeoCardCornerSplash.
class NeoCardCornerSplashPainter extends CustomPainter {
  final List<Color> colors;
  final double splashSize;
  final BorderRadius borderRadius;

  NeoCardCornerSplashPainter({
    required this.colors,
    required this.splashSize,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = RadialGradient(
      center: Alignment.topRight,
      radius: 1.0,
      colors: colors,
      stops: const [0.0, 0.3, 0.6, 1.0],
    );

    final rect = Rect.fromLTWH(
      size.width - splashSize,
      -splashSize * 0.3,
      splashSize * 1.3,
      splashSize * 1.3,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(NeoCardCornerSplashPainter oldDelegate) {
    return colors != oldDelegate.colors ||
        splashSize != oldDelegate.splashSize ||
        borderRadius != oldDelegate.borderRadius;
  }
}
