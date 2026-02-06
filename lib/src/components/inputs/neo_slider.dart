import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_slider_bouncy.dart';
import 'neo_slider_glass_fill.dart';
import 'neo_slider_glow_dot.dart';
import 'neo_slider_labeled.dart';
import 'neo_slider_minimal.dart';
import 'neo_slider_painter.dart';
import 'neo_slider_particles.dart';
import 'neo_slider_pulse_glow.dart';
import 'neo_slider_radial_fill.dart';

/// NeoSlider - A subtle, minimal slider with thin track and gradient active portion.
///
/// Features:
/// - Thin 3px track with rounded ends
/// - Gradient active track from primary to secondary color
/// - White thumb with primary border and soft glow
/// - Thumb grows slightly when dragging
///
/// Named constructors for slider variants:
/// - [NeoSlider.glassFill] - Glass track with gradient fill and glass thumb
/// - [NeoSlider.glowDot] - Minimal with glowing dot thumb
/// - [NeoSlider.radialFill] - Gradient follows thumb position
/// - [NeoSlider.bouncy] - Bouncy thumb animation
/// - [NeoSlider.minimal] - Only active portion visible
/// - [NeoSlider.pulseGlow] - Pulsing aura from thumb
/// - [NeoSlider.labeled] - Thumb shows value
/// - [NeoSlider.particles] - Dot particles track
class NeoSlider extends StatefulWidget {
  /// The current value of the slider.
  final double value;

  /// Called when the user changes the value.
  final ValueChanged<double>? onChanged;

  /// The minimum value. Defaults to 0.0.
  final double min;

  /// The maximum value. Defaults to 1.0.
  final double max;

  /// Optional track height. Defaults to 3.0.
  final double? trackHeight;

  /// Optional thumb size (radius when not dragging). Defaults to 8.0.
  final double? thumbSize;

  /// Optional active track color (start of gradient). Defaults to theme primary color.
  final Color? activeTrackColor;

  /// Optional secondary track color (end of gradient). Defaults to theme secondary color.
  final Color? activeTrackColorSecondary;

  /// Optional inactive track color. Defaults to borderColor with 0.3 alpha.
  final Color? inactiveTrackColor;

  const NeoSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.trackHeight,
    this.thumbSize,
    this.activeTrackColor,
    this.activeTrackColorSecondary,
    this.inactiveTrackColor,
  });

  /// Creates a glass fill slider with frosted glass track and gradient fill.
  ///
  /// Features a frosted glass track, a gradient fill showing the value,
  /// and a glass thumb with subtle inner glow.
  static Widget glassFill({
    Key? key,
    required double value,
    ValueChanged<double>? onChanged,
    double min = 0.0,
    double max = 1.0,
  }) {
    return NeoSliderGlassFill(
      key: key,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
    );
  }

  /// Creates a glow dot slider with thin gradient line and glowing thumb.
  ///
  /// A minimal slider with a thin gradient line as the track and
  /// a glowing circular thumb that emanates light.
  static Widget glowDot({
    Key? key,
    required double value,
    ValueChanged<double>? onChanged,
    double min = 0.0,
    double max = 1.0,
  }) {
    return NeoSliderGlowDot(
      key: key,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
    );
  }

  /// Creates a radial fill slider where the gradient follows the thumb.
  ///
  /// A slider with a glass track where the gradient fill dynamically
  /// adjusts its center point to follow the thumb position.
  static Widget radialFill({
    Key? key,
    required double value,
    ValueChanged<double>? onChanged,
    double min = 0.0,
    double max = 1.0,
  }) {
    return NeoSliderRadialFill(
      key: key,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
    );
  }

  /// Creates a bouncy slider with animated thumb scaling.
  ///
  /// A slider with a large rounded glass track and an animated
  /// bouncy thumb that scales when interacted with.
  static Widget bouncy({
    Key? key,
    required double value,
    ValueChanged<double>? onChanged,
    double min = 0.0,
    double max = 1.0,
  }) {
    return NeoSliderBouncy(
      key: key,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
    );
  }

  /// Creates a minimal slider showing only the active portion.
  ///
  /// A minimalist slider that shows only the gradient-filled active
  /// portion with a subtle track line underneath.
  static Widget minimal({
    Key? key,
    required double value,
    ValueChanged<double>? onChanged,
    double min = 0.0,
    double max = 1.0,
  }) {
    return NeoSliderMinimal(
      key: key,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
    );
  }

  /// Creates a pulse glow slider with emanating gradient glow.
  ///
  /// A slider where the thumb creates a radial gradient glow that
  /// spreads across the track, creating a dramatic lighting effect.
  static Widget pulseGlow({
    Key? key,
    required double value,
    ValueChanged<double>? onChanged,
    double min = 0.0,
    double max = 1.0,
  }) {
    return NeoSliderPulseGlow(
      key: key,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
    );
  }

  /// Creates a labeled slider with value displayed in the thumb.
  ///
  /// A slider with a glass track and a gradient-filled thumb that
  /// displays the current value as a percentage inside.
  static Widget labeled({
    Key? key,
    required double value,
    ValueChanged<double>? onChanged,
    double min = 0.0,
    double max = 1.0,
  }) {
    return NeoSliderLabeled(
      key: key,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
    );
  }

  /// Creates a particles slider with dot particles along the track.
  ///
  /// A slider where the track is made up of gradient-colored dots
  /// that light up progressively based on the value.
  static Widget particles({
    Key? key,
    required double value,
    ValueChanged<double>? onChanged,
    double min = 0.0,
    double max = 1.0,
  }) {
    return NeoSliderParticles(
      key: key,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
    );
  }

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
    final effectiveThumbSize = widget.thumbSize ?? 8.0;
    final double thumbRadius = isDragging ? effectiveThumbSize + 2.0 : effectiveThumbSize;
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

    final effectiveTrackHeight = widget.trackHeight ?? 3.0;
    final effectiveThumbSize = widget.thumbSize ?? 8.0;
    final effectivePrimaryColor = widget.activeTrackColor ?? colors.primary;
    final effectiveSecondaryColor = widget.activeTrackColorSecondary ?? colors.secondary;

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
            primaryColor: effectivePrimaryColor,
            secondaryColor: effectiveSecondaryColor,
            borderColor: colors.border,
            isDragging: isDragging,
            trackHeight: effectiveTrackHeight,
            thumbSize: effectiveThumbSize,
            inactiveTrackColor: widget.inactiveTrackColor,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
