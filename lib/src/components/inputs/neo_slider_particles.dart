import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import 'neo_slider_particles_painter.dart';

/// NeoSliderParticles - Slider with gradient particles/dots along track
///
/// A slider where the track is made up of gradient-colored dots
/// that light up progressively based on the value.
class NeoSliderParticles extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;

  const NeoSliderParticles({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  State<NeoSliderParticles> createState() => NeoSliderParticlesState();
}

class NeoSliderParticlesState extends State<NeoSliderParticles> with SingleTickerProviderStateMixin {
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
            painter: NeoSliderParticlesPainter(
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
