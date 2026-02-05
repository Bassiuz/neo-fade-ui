import 'package:flutter/widgets.dart';

class GradientBorderPainter extends CustomPainter {
  final List<Color> colors;
  final double borderWidth;
  final BorderRadius borderRadius;
  final bool bottomOnly;

  GradientBorderPainter({
    required this.colors,
    required this.borderWidth,
    required this.borderRadius,
    this.bottomOnly = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (borderWidth <= 0 || colors.isEmpty) return;

    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: colors,
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    if (bottomOnly) {
      final bottomRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(
          0,
          size.height - borderWidth,
          size.width,
          borderWidth,
        ),
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      );
      canvas.drawRRect(bottomRect, paint);
    } else {
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
  }

  @override
  bool shouldRepaint(GradientBorderPainter oldDelegate) {
    return colors != oldDelegate.colors ||
        borderWidth != oldDelegate.borderWidth ||
        borderRadius != oldDelegate.borderRadius ||
        bottomOnly != oldDelegate.bottomOnly;
  }
}

class GradientBorder extends StatelessWidget {
  final List<Color> colors;
  final double borderWidth;
  final BorderRadius borderRadius;
  final bool bottomOnly;
  final Widget? child;

  const GradientBorder({
    super.key,
    required this.colors,
    this.borderWidth = 5.0,
    this.borderRadius = BorderRadius.zero,
    this.bottomOnly = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GradientBorderPainter(
        colors: colors,
        borderWidth: borderWidth,
        borderRadius: borderRadius,
        bottomOnly: bottomOnly,
      ),
      child: child,
    );
  }
}
