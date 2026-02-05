import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'corner_position.dart';

/// Custom painter for drawing gradient badges in the corners.
///
/// Creates decorative gradient badges that appear in all four corners
/// with animation support via the progress parameter.
class CornerGradientBadgePainter extends CustomPainter {
  final List<Color> gradientColors;
  final double progress;
  final double borderRadius;
  final double badgeSize;

  CornerGradientBadgePainter({
    required this.gradientColors,
    required this.progress,
    required this.borderRadius,
    required this.badgeSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || gradientColors.isEmpty) return;

    final effectiveSize = badgeSize * progress;
    final opacity = progress;

    final topLeftGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: gradientColors.map((c) => c.withValues(alpha: opacity)).toList(),
    );

    final topRightGradient = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: gradientColors.reversed.map((c) => c.withValues(alpha: opacity)).toList(),
    );

    final bottomLeftGradient = LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: gradientColors.reversed.map((c) => c.withValues(alpha: opacity)).toList(),
    );

    final bottomRightGradient = LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: gradientColors.map((c) => c.withValues(alpha: opacity)).toList(),
    );

    _drawCornerBadge(
      canvas,
      Offset(0, 0),
      effectiveSize,
      topLeftGradient,
      CornerPosition.topLeft,
    );

    _drawCornerBadge(
      canvas,
      Offset(size.width, 0),
      effectiveSize,
      topRightGradient,
      CornerPosition.topRight,
    );

    _drawCornerBadge(
      canvas,
      Offset(0, size.height),
      effectiveSize,
      bottomLeftGradient,
      CornerPosition.bottomLeft,
    );

    _drawCornerBadge(
      canvas,
      Offset(size.width, size.height),
      effectiveSize,
      bottomRightGradient,
      CornerPosition.bottomRight,
    );
  }

  void _drawCornerBadge(
    Canvas canvas,
    Offset corner,
    double size,
    LinearGradient gradient,
    CornerPosition position,
  ) {
    final path = Path();

    switch (position) {
      case CornerPosition.topLeft:
        path.moveTo(corner.dx, corner.dy + borderRadius);
        path.lineTo(corner.dx, corner.dy + size);
        path.lineTo(corner.dx + size * 0.3, corner.dy + size * 0.7);
        path.lineTo(corner.dx + size * 0.7, corner.dy + size * 0.3);
        path.lineTo(corner.dx + size, corner.dy);
        path.lineTo(corner.dx + borderRadius, corner.dy);
        path.arcTo(
          Rect.fromCircle(
            center: Offset(corner.dx + borderRadius, corner.dy + borderRadius),
            radius: borderRadius,
          ),
          -math.pi / 2,
          -math.pi / 2,
          false,
        );
        break;
      case CornerPosition.topRight:
        path.moveTo(corner.dx - borderRadius, corner.dy);
        path.lineTo(corner.dx - size, corner.dy);
        path.lineTo(corner.dx - size * 0.7, corner.dy + size * 0.3);
        path.lineTo(corner.dx - size * 0.3, corner.dy + size * 0.7);
        path.lineTo(corner.dx, corner.dy + size);
        path.lineTo(corner.dx, corner.dy + borderRadius);
        path.arcTo(
          Rect.fromCircle(
            center: Offset(corner.dx - borderRadius, corner.dy + borderRadius),
            radius: borderRadius,
          ),
          0,
          -math.pi / 2,
          false,
        );
        break;
      case CornerPosition.bottomLeft:
        path.moveTo(corner.dx, corner.dy - borderRadius);
        path.lineTo(corner.dx, corner.dy - size);
        path.lineTo(corner.dx + size * 0.3, corner.dy - size * 0.7);
        path.lineTo(corner.dx + size * 0.7, corner.dy - size * 0.3);
        path.lineTo(corner.dx + size, corner.dy);
        path.lineTo(corner.dx + borderRadius, corner.dy);
        path.arcTo(
          Rect.fromCircle(
            center: Offset(corner.dx + borderRadius, corner.dy - borderRadius),
            radius: borderRadius,
          ),
          math.pi / 2,
          math.pi / 2,
          false,
        );
        break;
      case CornerPosition.bottomRight:
        path.moveTo(corner.dx - borderRadius, corner.dy);
        path.lineTo(corner.dx - size, corner.dy);
        path.lineTo(corner.dx - size * 0.7, corner.dy - size * 0.3);
        path.lineTo(corner.dx - size * 0.3, corner.dy - size * 0.7);
        path.lineTo(corner.dx, corner.dy - size);
        path.lineTo(corner.dx, corner.dy - borderRadius);
        path.arcTo(
          Rect.fromCircle(
            center: Offset(corner.dx - borderRadius, corner.dy - borderRadius),
            radius: borderRadius,
          ),
          0,
          math.pi / 2,
          false,
        );
        break;
    }

    path.close();

    final rect = path.getBounds();
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CornerGradientBadgePainter oldDelegate) {
    return progress != oldDelegate.progress ||
        gradientColors != oldDelegate.gradientColors ||
        borderRadius != oldDelegate.borderRadius ||
        badgeSize != oldDelegate.badgeSize;
  }
}
