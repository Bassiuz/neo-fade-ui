import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// NeoSlider5 - Minimal slider with just gradient active portion
///
/// A minimalist slider that shows only the gradient-filled active
/// portion with a subtle track line underneath.
class NeoSlider5 extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;

  const NeoSlider5({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  State<NeoSlider5> createState() => NeoSlider5State();
}

class NeoSlider5State extends State<NeoSlider5> {
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
    final double padding = 8.0;
    final double trackWidth = box.size.width - padding * 2;
    final double newValue = ((position.dx - padding) / trackWidth).clamp(0.0, 1.0);
    final double mappedValue = widget.min + newValue * (widget.max - widget.min);
    widget.onChanged!(mappedValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;

    return GestureDetector(
      onHorizontalDragStart: handleDragStart,
      onHorizontalDragUpdate: handleDragUpdate,
      onHorizontalDragEnd: handleDragEnd,
      onTapDown: handleTapDown,
      child: AnimatedContainer(
        duration: NeoFadeAnimations.fast,
        height: 40,
        child: CustomPaint(
          painter: NeoSlider5Painter(
            value: normalizedValue,
            primaryColor: colors.primary,
            secondaryColor: colors.secondary,
            tertiaryColor: colors.tertiary,
            surfaceColor: colors.surface,
            borderColor: colors.border,
            isDragging: isDragging,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class NeoSlider5Painter extends CustomPainter {
  final double value;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final bool isDragging;

  NeoSlider5Painter({
    required this.value,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.isDragging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double trackHeight = isDragging ? 8.0 : 6.0;
    final double padding = 8.0;
    final double trackY = (size.height - trackHeight) / 2;
    final double trackLeft = padding;
    final double trackRight = size.width - padding;
    final double trackWidth = trackRight - trackLeft;

    // Background track line (very subtle)
    final bgTrackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight),
      Radius.circular(trackHeight / 2),
    );

    final bgPaint = Paint()
      ..color = surfaceColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(bgTrackRect, bgPaint);

    // Subtle border on background
    final bgBorderPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawRRect(bgTrackRect, bgBorderPaint);

    // Active portion with gradient
    final activeWidth = trackWidth * value;
    if (activeWidth > 0) {
      final activeRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(trackLeft, trackY, activeWidth, trackHeight),
        Radius.circular(trackHeight / 2),
      );

      // Main gradient fill
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
            tertiaryColor,
          ],
        ).createShader(Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight))
        ..style = PaintingStyle.fill;
      canvas.drawRRect(activeRect, gradientPaint);

      // Subtle glow under active portion
      final glowPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            primaryColor.withValues(alpha: 0.3),
            secondaryColor.withValues(alpha: 0.2),
            tertiaryColor.withValues(alpha: 0.1),
          ],
        ).createShader(Rect.fromLTWH(trackLeft, trackY, trackWidth, trackHeight))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawRRect(activeRect, glowPaint);

      // Top shine
      final shineRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(trackLeft, trackY, activeWidth, trackHeight / 2),
        Radius.circular(trackHeight / 2),
      );
      final shinePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFFFFFF).withValues(alpha: 0.4),
            const Color(0xFFFFFFFF).withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(trackLeft, trackY, activeWidth, trackHeight / 2))
        ..style = PaintingStyle.fill;
      canvas.drawRRect(shineRect, shinePaint);

      // End cap indicator (small circle at the end)
      if (isDragging) {
        final endX = trackLeft + activeWidth;
        final endIndicatorPaint = Paint()
          ..color = const Color(0xFFFFFFFF)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(endX, size.height / 2), trackHeight / 2 + 2, endIndicatorPaint);

        // Gradient overlay on end cap
        final endGradientPaint = Paint()
          ..shader = RadialGradient(
            colors: [
              primaryColor,
              secondaryColor,
            ],
          ).createShader(Rect.fromCircle(center: Offset(endX, size.height / 2), radius: trackHeight / 2 + 2))
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(endX, size.height / 2), trackHeight / 2 + 1, endGradientPaint);
      }
    }
  }

  @override
  bool shouldRepaint(NeoSlider5Painter oldDelegate) {
    return value != oldDelegate.value ||
        primaryColor != oldDelegate.primaryColor ||
        isDragging != oldDelegate.isDragging;
  }
}
