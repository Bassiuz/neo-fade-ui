import 'package:flutter/widgets.dart';

/// Custom painter for drawing a gradient shimmer effect.
///
/// Creates an animated shimmer that sweeps across the gradient colors.
class GradientShimmerPainter extends CustomPainter {
  final List<Color> gradientColors;
  final double shimmerProgress;

  GradientShimmerPainter({
    required this.gradientColors,
    required this.shimmerProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final extendedColors = [
      ...gradientColors,
      ...gradientColors,
      gradientColors.first,
    ];

    final stops = <double>[];
    final colorCount = extendedColors.length;
    for (int i = 0; i < colorCount; i++) {
      stops.add(i / (colorCount - 1));
    }

    final shiftedStops = stops.map((s) {
      final shifted = s - shimmerProgress;
      if (shifted < 0) return shifted + 1.0;
      if (shifted > 1) return shifted - 1.0;
      return shifted;
    }).toList();

    final sortedIndices = List.generate(colorCount, (i) => i)
      ..sort((a, b) => shiftedStops[a].compareTo(shiftedStops[b]));

    final sortedColors = sortedIndices.map((i) => extendedColors[i]).toList();
    final sortedStops = sortedIndices.map((i) => shiftedStops[i]).toList();

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: sortedColors,
        stops: sortedStops,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(GradientShimmerPainter oldDelegate) {
    return shimmerProgress != oldDelegate.shimmerProgress ||
        gradientColors != oldDelegate.gradientColors;
  }
}
