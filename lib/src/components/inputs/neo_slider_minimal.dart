import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_slider_minimal_painter.dart';

/// NeoSliderMinimal - Minimal slider with just gradient active portion
///
/// A minimalist slider that shows only the gradient-filled active
/// portion with a subtle track line underneath.
class NeoSliderMinimal extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;

  const NeoSliderMinimal({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  State<NeoSliderMinimal> createState() => NeoSliderMinimalState();
}

class NeoSliderMinimalState extends State<NeoSliderMinimal> {
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
          painter: NeoSliderMinimalPainter(
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
