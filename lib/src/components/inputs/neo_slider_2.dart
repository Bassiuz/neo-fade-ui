import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';

/// NeoSlider2 - Thin gradient line track with glowing dot thumb
///
/// A minimal slider with a thin gradient line as the track and
/// a glowing circular thumb that emanates light.
class NeoSlider2 extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;

  const NeoSlider2({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  State<NeoSlider2> createState() => NeoSlider2State();
}

class NeoSlider2State extends State<NeoSlider2> with SingleTickerProviderStateMixin {
  bool isDragging = false;
  late AnimationController glowController;
  late Animation<double> glowAnimation;

  double get normalizedValue => ((widget.value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();
    glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    glowController.dispose();
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
    final double padding = 16.0;
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
      child: AnimatedBuilder(
        animation: glowAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: NeoSlider2Painter(
              value: normalizedValue,
              primaryColor: colors.primary,
              secondaryColor: colors.secondary,
              tertiaryColor: colors.tertiary,
              surfaceColor: colors.surface,
              isDragging: isDragging,
              glowIntensity: glowAnimation.value,
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

class NeoSlider2Painter extends CustomPainter {
  final double value;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color surfaceColor;
  final bool isDragging;
  final double glowIntensity;

  NeoSlider2Painter({
    required this.value,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.surfaceColor,
    required this.isDragging,
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double trackHeight = 3.0;
    final double thumbRadius = isDragging ? 10.0 : 8.0;
    final double padding = 16.0;
    final double trackY = size.height / 2;
    final double trackLeft = padding;
    final double trackRight = size.width - padding;
    final double trackWidth = trackRight - trackLeft;

    // Inactive track (subtle)
    final inactiveTrackPaint = Paint()
      ..color = surfaceColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackHeight
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(trackLeft, trackY),
      Offset(trackRight, trackY),
      inactiveTrackPaint,
    );

    // Active gradient track
    final activeWidth = trackWidth * value;
    if (activeWidth > 0) {
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          colors: [primaryColor, secondaryColor, tertiaryColor],
        ).createShader(Rect.fromLTWH(trackLeft, trackY - trackHeight / 2, trackWidth, trackHeight))
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackHeight
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(trackLeft, trackY),
        Offset(trackLeft + activeWidth, trackY),
        gradientPaint,
      );
    }

    // Thumb position
    final thumbX = trackLeft + trackWidth * value;

    // Outer glow
    final outerGlowRadius = thumbRadius * 3 * glowIntensity;
    final outerGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.4 * glowIntensity),
          secondaryColor.withValues(alpha: 0.2 * glowIntensity),
          tertiaryColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, trackY), radius: outerGlowRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, trackY), outerGlowRadius, outerGlowPaint);

    // Inner glow
    final innerGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.8),
          secondaryColor.withValues(alpha: 0.4),
        ],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, trackY), radius: thumbRadius * 1.5))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(thumbX, trackY), thumbRadius * 1.5, innerGlowPaint);

    // Solid thumb center
    final thumbPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFFFFF),
          primaryColor,
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(thumbX, trackY), radius: thumbRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, trackY), thumbRadius, thumbPaint);
  }

  @override
  bool shouldRepaint(NeoSlider2Painter oldDelegate) {
    return value != oldDelegate.value ||
        primaryColor != oldDelegate.primaryColor ||
        isDragging != oldDelegate.isDragging ||
        glowIntensity != oldDelegate.glowIntensity;
  }
}
