import 'package:flutter/widgets.dart';

class InnerBorderPainter extends CustomPainter {
  final Color color;
  final double width;
  final BorderRadius borderRadius;

  InnerBorderPainter({
    required this.color,
    required this.width,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (width <= 0 || color.a == 0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final rect = Rect.fromLTWH(
      width / 2,
      width / 2,
      size.width - width,
      size.height - width,
    );

    final adjustedRadius = BorderRadius.only(
      topLeft: Radius.circular((borderRadius.topLeft.x - width / 2).clamp(0, double.infinity)),
      topRight: Radius.circular((borderRadius.topRight.x - width / 2).clamp(0, double.infinity)),
      bottomLeft: Radius.circular((borderRadius.bottomLeft.x - width / 2).clamp(0, double.infinity)),
      bottomRight: Radius.circular((borderRadius.bottomRight.x - width / 2).clamp(0, double.infinity)),
    );

    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: adjustedRadius.topLeft,
      topRight: adjustedRadius.topRight,
      bottomLeft: adjustedRadius.bottomLeft,
      bottomRight: adjustedRadius.bottomRight,
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(InnerBorderPainter oldDelegate) {
    return color != oldDelegate.color ||
        width != oldDelegate.width ||
        borderRadius != oldDelegate.borderRadius;
  }
}

class InnerBorder extends StatelessWidget {
  final Color color;
  final double width;
  final BorderRadius borderRadius;
  final Widget? child;

  const InnerBorder({
    super.key,
    required this.color,
    this.width = 1.0,
    this.borderRadius = BorderRadius.zero,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: InnerBorderPainter(
        color: color,
        width: width,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
