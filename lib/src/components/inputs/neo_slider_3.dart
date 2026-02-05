import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// NeoSlider3 - Glass track with gradient that follows thumb position
///
/// A slider with a glass track where the gradient fill dynamically
/// adjusts its center point to follow the thumb position.
class NeoSlider3 extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;

  const NeoSlider3({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  State<NeoSlider3> createState() => NeoSlider3State();
}

class NeoSlider3State extends State<NeoSlider3> {
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
    final double thumbRadius = 12.0;
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
          painter: NeoSlider3Painter(
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

class NeoSlider3Painter extends CustomPainter {
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

  NeoSlider3Painter({
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
    final double trackHeight = 12.0;
    final double thumbRadius = isDragging ? 14.0 : 12.0;
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
      ..color = surfaceColor.withValues(alpha: tintOpacity * 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(trackRect, trackPaint);

    // Gradient fill that follows thumb
    final thumbX = trackLeft + trackWidth * value;
    final gradientCenter = Alignment(value * 2 - 1, 0);

    final fillRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight),
      Radius.circular(trackHeight / 2),
    );

    // Radial gradient centered on thumb position
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        center: gradientCenter,
        radius: 1.5,
        colors: [
          primaryColor.withValues(alpha: 0.9),
          secondaryColor.withValues(alpha: 0.6),
          tertiaryColor.withValues(alpha: 0.3),
          surfaceColor.withValues(alpha: 0.1),
        ],
        stops: const [0.0, 0.3, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight))
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.clipRRect(fillRect);
    canvas.drawRRect(fillRect, gradientPaint);
    canvas.restore();

    // Track border
    final trackBorderPaint = Paint()
      ..color = borderColor.withValues(alpha: borderOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(trackRect, trackBorderPaint);

    // Inner light border
    final innerBorderRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(trackLeft + 1, trackY + 1, trackWidth - 2, trackHeight - 2),
      Radius.circular((trackHeight - 2) / 2),
    );
    final innerBorderPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawRRect(innerBorderRect, innerBorderPaint);

    // Thumb shadow
    final shadowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(thumbX, size.height / 2), thumbRadius * 0.9, shadowPaint);

    // Thumb glass background
    final thumbPaint = Paint()
      ..color = surfaceColor.withValues(alpha: tintOpacity * 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, size.height / 2), thumbRadius, thumbPaint);

    // Thumb gradient overlay
    final thumbGradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryColor.withValues(alpha: 0.5),
          secondaryColor.withValues(alpha: 0.3),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, size.height / 2), radius: thumbRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, size.height / 2), thumbRadius, thumbGradientPaint);

    // Thumb border
    final thumbBorderPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: borderOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(thumbX, size.height / 2), thumbRadius, thumbBorderPaint);

    // Thumb highlight
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.4),
        radius: 0.8,
        colors: [
          const Color(0xFFFFFFFF).withValues(alpha: 0.5),
          const Color(0xFFFFFFFF).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, size.height / 2), radius: thumbRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, size.height / 2), thumbRadius * 0.7, highlightPaint);
  }

  @override
  bool shouldRepaint(NeoSlider3Painter oldDelegate) {
    return value != oldDelegate.value ||
        primaryColor != oldDelegate.primaryColor ||
        isDragging != oldDelegate.isDragging;
  }
}
