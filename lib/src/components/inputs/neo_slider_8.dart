import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';

/// NeoSlider8 - Slider with gradient particles/dots along track
///
/// A slider where the track is made up of gradient-colored dots
/// that light up progressively based on the value.
class NeoSlider8 extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;

  const NeoSlider8({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  State<NeoSlider8> createState() => NeoSlider8State();
}

class NeoSlider8State extends State<NeoSlider8> with SingleTickerProviderStateMixin {
  bool isDragging = false;
  late AnimationController shimmerController;
  late Animation<double> shimmerAnimation;

  double get normalizedValue => ((widget.value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();
    shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    shimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(shimmerController);
  }

  @override
  void dispose() {
    shimmerController.dispose();
    super.dispose();
  }

  void handleDragStart(DragStartDetails details) {
    setState(() => isDragging = true);
    updateValue(details.localPosition);
  }

  void handleDragUpdate(DragUpdateDetails details) {
    updateValue(details.localPosition);
  }

  void handleDragEnd(DragEndDetails details) {
    setState(() => isDragging = false);
  }

  void handleTapDown(TapDownDetails details) {
    updateValue(details.localPosition);
  }

  void updateValue(Offset position) {
    if (widget.onChanged == null) return;
    final RenderBox box = context.findRenderObject() as RenderBox;
    final double thumbRadius = 14.0;
    final double trackWidth = box.size.width - thumbRadius * 2;
    final double newValue = ((position.dx - thumbRadius) / trackWidth).clamp(0.0, 1.0);
    final double mappedValue = widget.min + newValue * (widget.max - widget.min);
    widget.onChanged!(mappedValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    return GestureDetector(
      onHorizontalDragStart: handleDragStart,
      onHorizontalDragUpdate: handleDragUpdate,
      onHorizontalDragEnd: handleDragEnd,
      onTapDown: handleTapDown,
      child: AnimatedBuilder(
        animation: shimmerAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: NeoSlider8Painter(
              value: normalizedValue,
              primaryColor: colors.primary,
              secondaryColor: colors.secondary,
              tertiaryColor: colors.tertiary,
              surfaceColor: colors.surface,
              borderColor: colors.border,
              tintOpacity: glass.tintOpacity,
              borderOpacity: glass.borderOpacity,
              isDragging: isDragging,
              shimmerProgress: shimmerAnimation.value,
              isLight: colors.isLight,
            ),
            child: const SizedBox(
              height: 48,
              width: double.infinity,
            ),
          );
        },
      ),
    );
  }
}

class NeoSlider8Painter extends CustomPainter {
  final double value;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final double tintOpacity;
  final double borderOpacity;
  final bool isDragging;
  final double shimmerProgress;
  final bool isLight;

  NeoSlider8Painter({
    required this.value,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.tintOpacity,
    required this.borderOpacity,
    required this.isDragging,
    required this.shimmerProgress,
    required this.isLight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double thumbRadius = isDragging ? 16.0 : 14.0;
    final double trackLeft = thumbRadius;
    final double trackRight = size.width - thumbRadius;
    final double trackWidth = trackRight - trackLeft;
    final double centerY = size.height / 2;

    // Number of dots
    final int dotCount = 20;
    final double dotSpacing = trackWidth / (dotCount - 1);
    final double baseDotRadius = 4.0;

    // Draw dots
    for (int i = 0; i < dotCount; i++) {
      final double dotX = trackLeft + i * dotSpacing;
      final double dotProgress = i / (dotCount - 1);
      final bool isActive = dotProgress <= value;

      // Calculate shimmer effect for active dots
      final double shimmerOffset = (shimmerProgress + dotProgress) % 1.0;
      final double shimmerIntensity = isActive ? math.sin(shimmerOffset * math.pi) * 0.3 + 0.7 : 0.3;

      // Dot size varies slightly based on position
      final double dotRadius = baseDotRadius * (isActive ? (isDragging ? 1.3 : 1.1) : 0.8);

      // Calculate gradient color for this dot position
      Color dotColor;
      if (dotProgress < 0.5) {
        dotColor = Color.lerp(primaryColor, secondaryColor, dotProgress * 2)!;
      } else {
        dotColor = Color.lerp(secondaryColor, tertiaryColor, (dotProgress - 0.5) * 2)!;
      }

      if (isActive) {
        // Glow for active dots
        final glowPaint = Paint()
          ..color = dotColor.withValues(alpha: 0.4 * shimmerIntensity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
        canvas.drawCircle(Offset(dotX, centerY), dotRadius * 2, glowPaint);

        // Active dot fill
        final dotPaint = Paint()
          ..shader = RadialGradient(
            colors: [
              dotColor.withValues(alpha: shimmerIntensity),
              dotColor.withValues(alpha: shimmerIntensity * 0.7),
            ],
          ).createShader(Rect.fromCircle(center: Offset(dotX, centerY), radius: dotRadius))
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(dotX, centerY), dotRadius, dotPaint);

        // Dot highlight
        final highlightPaint = Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.3, -0.3),
            radius: 0.8,
            colors: [
              const Color(0xFFFFFFFF).withValues(alpha: 0.6 * shimmerIntensity),
              const Color(0xFFFFFFFF).withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromCircle(center: Offset(dotX, centerY), radius: dotRadius))
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(dotX, centerY), dotRadius * 0.7, highlightPaint);
      } else {
        // Inactive dot
        final inactivePaint = Paint()
          ..color = surfaceColor.withValues(alpha: tintOpacity * 0.4)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(dotX, centerY), dotRadius, inactivePaint);

        // Subtle border for inactive
        final borderPaint = Paint()
          ..color = borderColor.withValues(alpha: borderOpacity * 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;
        canvas.drawCircle(Offset(dotX, centerY), dotRadius, borderPaint);
      }
    }

    // Thumb position
    final thumbX = trackLeft + trackWidth * value;

    // Connection line to nearest dots (subtle)
    if (value > 0 && value < 1) {
      final nearestDotIndex = (value * (dotCount - 1)).round();
      final nearestDotX = trackLeft + nearestDotIndex * dotSpacing;

      final linePaint = Paint()
        ..shader = LinearGradient(
          colors: [
            primaryColor.withValues(alpha: 0.3),
            secondaryColor.withValues(alpha: 0.3),
          ],
        ).createShader(Rect.fromLTWH(math.min(thumbX, nearestDotX), centerY - 1, (thumbX - nearestDotX).abs(), 2))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawLine(Offset(nearestDotX, centerY), Offset(thumbX, centerY), linePaint);
    }

    // Thumb shadow
    final shadowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(thumbX, centerY), thumbRadius, shadowPaint);

    // Thumb background (glass)
    final thumbBgPaint = Paint()
      ..color = surfaceColor.withValues(alpha: tintOpacity * 0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, centerY), thumbRadius, thumbBgPaint);

    // Thumb gradient
    final thumbGradientPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.2),
        colors: [
          primaryColor.withValues(alpha: 0.8),
          secondaryColor.withValues(alpha: 0.5),
          tertiaryColor.withValues(alpha: 0.3),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, centerY), radius: thumbRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, centerY), thumbRadius, thumbGradientPaint);

    // Thumb border
    final thumbBorderPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: borderOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(thumbX, centerY), thumbRadius, thumbBorderPaint);

    // Thumb highlight
    final thumbHighlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.4),
        radius: 0.6,
        colors: [
          const Color(0xFFFFFFFF).withValues(alpha: 0.6),
          const Color(0xFFFFFFFF).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, centerY), radius: thumbRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, centerY), thumbRadius * 0.5, thumbHighlightPaint);
  }

  @override
  bool shouldRepaint(NeoSlider8Painter oldDelegate) {
    return value != oldDelegate.value ||
        primaryColor != oldDelegate.primaryColor ||
        isDragging != oldDelegate.isDragging ||
        shimmerProgress != oldDelegate.shimmerProgress;
  }
}
