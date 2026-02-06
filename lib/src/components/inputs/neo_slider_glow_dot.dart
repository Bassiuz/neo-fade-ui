import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import 'neo_slider_glow_dot_painter.dart';

/// NeoSliderGlowDot - Thin gradient line track with glowing dot thumb
///
/// A minimal slider with a thin gradient line as the track and
/// a glowing circular thumb that emanates light.
class NeoSliderGlowDot extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;

  const NeoSliderGlowDot({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  State<NeoSliderGlowDot> createState() => NeoSliderGlowDotState();
}

class NeoSliderGlowDotState extends State<NeoSliderGlowDot> with SingleTickerProviderStateMixin {
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
            painter: NeoSliderGlowDotPainter(
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
