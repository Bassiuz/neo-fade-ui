import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// NeoSlider7 - Glass track with gradient thumb that shows value
///
/// A slider with a glass track and a gradient-filled thumb that
/// displays the current value as a percentage inside.
class NeoSlider7 extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;

  const NeoSlider7({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  State<NeoSlider7> createState() => NeoSlider7State();
}

class NeoSlider7State extends State<NeoSlider7> {
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
    final double thumbWidth = 44.0;
    final double trackWidth = box.size.width - thumbWidth;
    final double newValue = ((position.dx - thumbWidth / 2) / trackWidth).clamp(0.0, 1.0);
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
          painter: NeoSlider7Painter(
            value: normalizedValue,
            primaryColor: colors.primary,
            secondaryColor: colors.secondary,
            tertiaryColor: colors.tertiary,
            surfaceColor: colors.surface,
            borderColor: colors.border,
            onSurfaceColor: colors.onSurface,
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

class NeoSlider7Painter extends CustomPainter {
  final double value;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final Color onSurfaceColor;
  final double tintOpacity;
  final double borderOpacity;
  final bool isDragging;
  final bool isLight;

  NeoSlider7Painter({
    required this.value,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.onSurfaceColor,
    required this.tintOpacity,
    required this.borderOpacity,
    required this.isDragging,
    required this.isLight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double trackHeight = 8.0;
    final double thumbWidth = isDragging ? 48.0 : 44.0;
    final double thumbHeight = isDragging ? 28.0 : 24.0;
    final double trackY = (size.height - trackHeight) / 2;
    final double trackLeft = thumbWidth / 2;
    final double trackRight = size.width - thumbWidth / 2;
    final double trackWidth = trackRight - trackLeft;

    // Track background (glass)
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight),
      Radius.circular(trackHeight / 2),
    );

    final trackPaint = Paint()
      ..color = surfaceColor.withValues(alpha: tintOpacity * 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(trackRect, trackPaint);

    // Track gradient overlay
    final trackGradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          primaryColor.withValues(alpha: 0.1),
          secondaryColor.withValues(alpha: 0.1),
          tertiaryColor.withValues(alpha: 0.1),
        ],
      ).createShader(Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight))
      ..style = PaintingStyle.fill;
    canvas.drawRRect(trackRect, trackGradientPaint);

    // Track border
    final trackBorderPaint = Paint()
      ..color = borderColor.withValues(alpha: borderOpacity * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(trackRect, trackBorderPaint);

    // Active track fill
    final fillWidth = trackWidth * value;
    if (fillWidth > 0) {
      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(trackLeft, trackY, fillWidth, trackHeight),
        Radius.circular(trackHeight / 2),
      );

      final fillPaint = Paint()
        ..shader = LinearGradient(
          colors: [primaryColor, secondaryColor, tertiaryColor],
        ).createShader(Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight))
        ..style = PaintingStyle.fill;
      canvas.drawRRect(fillRect, fillPaint);
    }

    // Thumb position
    final thumbX = trackLeft + trackWidth * value;
    final thumbY = size.height / 2;
    final thumbRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(thumbX, thumbY), width: thumbWidth, height: thumbHeight),
      Radius.circular(thumbHeight / 2),
    );

    // Thumb shadow
    final shadowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRRect(thumbRect, shadowPaint);

    // Thumb background (glass)
    final thumbBgPaint = Paint()
      ..color = surfaceColor.withValues(alpha: tintOpacity * 0.9)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(thumbRect, thumbBgPaint);

    // Thumb gradient fill
    final thumbGradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryColor.withValues(alpha: 0.7),
          secondaryColor.withValues(alpha: 0.5),
          tertiaryColor.withValues(alpha: 0.4),
        ],
      ).createShader(Rect.fromCenter(center: Offset(thumbX, thumbY), width: thumbWidth, height: thumbHeight))
      ..style = PaintingStyle.fill;
    canvas.drawRRect(thumbRect, thumbGradientPaint);

    // Thumb border
    final thumbBorderPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: borderOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(thumbRect, thumbBorderPaint);

    // Thumb highlight
    final highlightRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(thumbX, thumbY - thumbHeight * 0.15), width: thumbWidth * 0.8, height: thumbHeight * 0.4),
      Radius.circular(thumbHeight / 4),
    );
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFFFFFF).withValues(alpha: 0.4),
          const Color(0xFFFFFFFF).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCenter(center: Offset(thumbX, thumbY - thumbHeight * 0.15), width: thumbWidth * 0.8, height: thumbHeight * 0.4))
      ..style = PaintingStyle.fill;
    canvas.drawRRect(highlightRect, highlightPaint);

    // Value text
    final percentage = (value * 100).round();
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$percentage',
        style: TextStyle(
          color: const Color(0xFFFFFFFF),
          fontSize: isDragging ? 11.0 : 10.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(thumbX - textPainter.width / 2, thumbY - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(NeoSlider7Painter oldDelegate) {
    return value != oldDelegate.value ||
        primaryColor != oldDelegate.primaryColor ||
        isDragging != oldDelegate.isDragging ||
        isLight != oldDelegate.isLight;
  }
}
