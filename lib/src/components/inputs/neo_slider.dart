import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_slider_painter.dart';

/// NeoSlider - A subtle, minimal slider with thin track and gradient active portion.
///
/// Features:
/// - Thin 3px track with rounded ends
/// - Gradient active track from primary to secondary color
/// - White thumb with primary border and soft glow
/// - Thumb grows slightly when dragging
class NeoSlider extends StatefulWidget {
  /// The current value of the slider.
  final double value;

  /// Called when the user changes the value.
  final ValueChanged<double>? onChanged;

  /// The minimum value. Defaults to 0.0.
  final double min;

  /// The maximum value. Defaults to 1.0.
  final double max;

  const NeoSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  State<NeoSlider> createState() => NeoSliderState();
}

/// State class for NeoSlider, managing drag interactions.
class NeoSliderState extends State<NeoSlider> {
  bool isDragging = false;

  double get normalizedValue =>
      ((widget.value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

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
    final double thumbRadius = isDragging ? 10.0 : 8.0;
    final double trackWidth = box.size.width - thumbRadius * 2;
    final double newValue =
        ((position.dx - thumbRadius) / trackWidth).clamp(0.0, 1.0);
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
        duration: isDragging ? Duration.zero : NeoFadeAnimations.fast,
        curve: NeoFadeAnimations.defaultCurve,
        height: 40,
        child: CustomPaint(
          painter: NeoSliderPainter(
            value: normalizedValue,
            primaryColor: colors.primary,
            secondaryColor: colors.secondary,
            borderColor: colors.border,
            isDragging: isDragging,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
