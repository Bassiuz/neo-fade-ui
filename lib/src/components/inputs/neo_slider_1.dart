import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// NeoSlider1 - Glass track with gradient fill and glass thumb
///
/// A slider with a frosted glass track, a gradient fill showing the value,
/// and a glass thumb with subtle inner glow.
class NeoSlider1 extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;

  const NeoSlider1({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  State<NeoSlider1> createState() => NeoSlider1State();
}

class NeoSlider1State extends State<NeoSlider1> {
  bool isDragging = false;

  double get normalizedValue => ((widget.value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

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
      child: AnimatedContainer(
        duration: NeoFadeAnimations.fast,
        height: 48,
        child: CustomPaint(
          painter: NeoSlider1Painter(
            value: normalizedValue,
            primaryColor: colors.primary,
            secondaryColor: colors.secondary,
            tertiaryColor: colors.tertiary,
            surfaceColor: colors.surface,
            borderColor: colors.border,
            blur: glass.blur,
            tintOpacity: glass.tintOpacity,
            borderOpacity: glass.borderOpacity,
            isDragging: isDragging,
            isLight: colors.isLight,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class NeoSlider1Painter extends CustomPainter {
  final double value;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final double blur;
  final double tintOpacity;
  final double borderOpacity;
  final bool isDragging;
  final bool isLight;

  NeoSlider1Painter({
    required this.value,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.blur,
    required this.tintOpacity,
    required this.borderOpacity,
    required this.isDragging,
    required this.isLight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double trackHeight = 8.0;
    final double thumbRadius = isDragging ? 16.0 : 14.0;
    final double trackY = (size.height - trackHeight) / 2;
    final double trackLeft = thumbRadius;
    final double trackRight = size.width - thumbRadius;
    final double trackWidth = trackRight - trackLeft;

    // Track background (glass effect)
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight),
      Radius.circular(trackHeight / 2),
    );

    final trackPaint = Paint()
      ..color = surfaceColor.withValues(alpha: tintOpacity * 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(trackRect, trackPaint);

    // Track border
    final trackBorderPaint = Paint()
      ..color = borderColor.withValues(alpha: borderOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(trackRect, trackBorderPaint);

    // Gradient fill
    final fillWidth = trackWidth * value;
    if (fillWidth > 0) {
      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(trackLeft, trackY, fillWidth, trackHeight),
        Radius.circular(trackHeight / 2),
      );

      final gradientPaint = Paint()
        ..shader = LinearGradient(
          colors: [primaryColor, secondaryColor, tertiaryColor],
        ).createShader(Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight))
        ..style = PaintingStyle.fill;
      canvas.drawRRect(fillRect, gradientPaint);
    }

    // Thumb position
    final thumbX = trackLeft + trackWidth * value;
    final thumbY = size.height / 2;

    // Thumb shadow
    final shadowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius, shadowPaint);

    // Thumb background (glass)
    final thumbPaint = Paint()
      ..color = surfaceColor.withValues(alpha: tintOpacity * 0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius, thumbPaint);

    // Thumb gradient overlay
    final thumbGradient = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.4),
          secondaryColor.withValues(alpha: 0.2),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, thumbY), radius: thumbRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius, thumbGradient);

    // Thumb border
    final thumbBorderPaint = Paint()
      ..color = (isLight ? const Color(0xFFFFFFFF) : const Color(0xFFFFFFFF)).withValues(alpha: borderOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius, thumbBorderPaint);

    // Inner highlight
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [
          const Color(0xFFFFFFFF).withValues(alpha: 0.4),
          const Color(0xFFFFFFFF).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, thumbY), radius: thumbRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius * 0.8, highlightPaint);
  }

  @override
  bool shouldRepaint(NeoSlider1Painter oldDelegate) {
    return value != oldDelegate.value ||
        primaryColor != oldDelegate.primaryColor ||
        secondaryColor != oldDelegate.secondaryColor ||
        tertiaryColor != oldDelegate.tertiaryColor ||
        isDragging != oldDelegate.isDragging ||
        isLight != oldDelegate.isLight;
  }
}
