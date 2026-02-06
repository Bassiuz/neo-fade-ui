import 'package:flutter/widgets.dart';

import 'neo_segment.dart';
import 'neo_segmented_control_sliding.dart';
import 'neo_segmented_control_pill_outline.dart';
import 'neo_segmented_control_underline.dart';
import 'neo_segmented_control_icon_grid.dart';

/// A unified segmented control widget with different visual styles.
///
/// Use the named constructors to create different variants:
/// - [NeoSegmentedControl.sliding] - Glass segmented control with sliding gradient indicator
/// - [NeoSegmentedControl.pillOutline] - Pill-shaped with gradient outline on selected
/// - [NeoSegmentedControl.underline] - Underline-style with gradient underline
/// - [NeoSegmentedControl.iconGrid] - Icon-only with gradient background on selected
abstract class NeoSegmentedControl<T> extends StatelessWidget {
  final T selectedValue;
  final ValueChanged<T> onValueChanged;
  final List<NeoSegment<T>> segments;

  const NeoSegmentedControl({
    super.key,
    required this.selectedValue,
    required this.onValueChanged,
    required this.segments,
  });

  /// Creates a glass segmented control with sliding gradient indicator.
  ///
  /// This variant features a smooth sliding animation when switching between segments,
  /// with a gradient background on the selected segment.
  static NeoSegmentedControlSliding<T> sliding<T>({
    Key? key,
    required T selectedValue,
    required ValueChanged<T> onValueChanged,
    required List<NeoSegment<T>> segments,
    double? borderRadius,
    double? padding,
    double? indicatorPadding,
    double? indicatorBorderRadius,
    TextStyle? textStyle,
  }) {
    return NeoSegmentedControlSliding<T>(
      key: key,
      selectedValue: selectedValue,
      onValueChanged: onValueChanged,
      segments: segments,
      borderRadius: borderRadius,
      padding: padding,
      indicatorPadding: indicatorPadding,
      indicatorBorderRadius: indicatorBorderRadius,
      textStyle: textStyle,
    );
  }

  /// Creates a pill-shaped segmented control with gradient outline on selected.
  ///
  /// Each segment is displayed as a pill, and the selected segment gets
  /// a gradient outline with a subtle glow effect.
  static NeoSegmentedControlPillOutline<T> pillOutline<T>({
    Key? key,
    required T selectedValue,
    required ValueChanged<T> onValueChanged,
    required List<NeoSegment<T>> segments,
  }) {
    return NeoSegmentedControlPillOutline<T>(
      key: key,
      selectedValue: selectedValue,
      onValueChanged: onValueChanged,
      segments: segments,
    );
  }

  /// Creates an underline-style segmented control with gradient underline.
  ///
  /// This variant displays segments in a row with an animated gradient underline
  /// that slides to indicate the selected segment.
  static NeoSegmentedControlUnderline<T> underline<T>({
    Key? key,
    required T selectedValue,
    required ValueChanged<T> onValueChanged,
    required List<NeoSegment<T>> segments,
  }) {
    return NeoSegmentedControlUnderline<T>(
      key: key,
      selectedValue: selectedValue,
      onValueChanged: onValueChanged,
      segments: segments,
    );
  }

  /// Creates an icon-only segmented control with gradient background on selected.
  ///
  /// Best suited for segments that primarily use icons. The selected segment
  /// gets a gradient background with a glow effect.
  static NeoSegmentedControlIconGrid<T> iconGrid<T>({
    Key? key,
    required T selectedValue,
    required ValueChanged<T> onValueChanged,
    required List<NeoSegment<T>> segments,
  }) {
    return NeoSegmentedControlIconGrid<T>(
      key: key,
      selectedValue: selectedValue,
      onValueChanged: onValueChanged,
      segments: segments,
    );
  }
}
