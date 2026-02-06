import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import 'neo_slider_bouncy_painter.dart';

/// NeoSliderBouncy - Rounded glass track with bouncy thumb
///
/// A slider with a large rounded glass track and an animated
/// bouncy thumb that scales when interacted with.
class NeoSliderBouncy extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;

  const NeoSliderBouncy({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  State<NeoSliderBouncy> createState() => NeoSliderBouncyState();
}

class NeoSliderBouncyState extends State<NeoSliderBouncy> with SingleTickerProviderStateMixin {
  bool isDragging = false;
  late AnimationController bounceController;
  late Animation<double> bounceAnimation;

  double get normalizedValue => ((widget.value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();
    bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    bounceAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    bounceController.dispose();
    super.dispose();
  }

  void handleDragStart(DragStartDetails details) {
    setState(() => isDragging = true);
    bounceController.forward();
    updateValue(details.localPosition);
  }

  void handleDragUpdate(DragUpdateDetails details) {
    updateValue(details.localPosition);
  }

  void handleDragEnd(DragEndDetails details) {
    setState(() => isDragging = false);
    bounceController.reverse();
  }

  void handleTapDown(TapDownDetails details) {
    bounceController.forward().then((_) => bounceController.reverse());
    updateValue(details.localPosition);
  }

  void updateValue(Offset position) {
    if (widget.onChanged == null) return;
    final RenderBox box = context.findRenderObject() as RenderBox;
    final double thumbRadius = 16.0;
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
        animation: bounceAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: NeoSliderBouncyPainter(
              value: normalizedValue,
              primaryColor: colors.primary,
              secondaryColor: colors.secondary,
              tertiaryColor: colors.tertiary,
              surfaceColor: colors.surface,
              borderColor: colors.border,
              tintOpacity: glass.tintOpacity,
              borderOpacity: glass.borderOpacity,
              isDragging: isDragging,
              thumbScale: bounceAnimation.value,
              isLight: colors.isLight,
            ),
            child: const SizedBox(
              height: 56,
              width: double.infinity,
            ),
          );
        },
      ),
    );
  }
}
