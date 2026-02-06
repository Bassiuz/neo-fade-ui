import 'package:flutter/widgets.dart';

import 'neo_number_selector_compact.dart';
import 'neo_number_selector_horizontal.dart';
import 'neo_number_selector_prominent.dart';
import 'neo_number_selector_vertical.dart';

/// A number selector widget with multiple style variants.
///
/// Use the named constructors to create different styles:
/// - [NeoNumberSelector.horizontal] - Horizontal +/- buttons
/// - [NeoNumberSelector.vertical] - Vertical arrows
/// - [NeoNumberSelector.compact] - Pill-shaped compact
/// - [NeoNumberSelector.prominent] - Large display
abstract class NeoNumberSelector extends StatelessWidget {
  const NeoNumberSelector._();

  /// Creates a horizontal number selector with +/- buttons.
  static Widget horizontal({
    Key? key,
    required int value,
    required ValueChanged<int> onChanged,
    int min = 0,
    int max = 100,
    int step = 1,
  }) {
    return NeoNumberSelectorHorizontal(
      key: key,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      step: step,
    );
  }

  /// Creates a vertical number selector with arrow buttons.
  static Widget vertical({
    Key? key,
    required int value,
    required ValueChanged<int> onChanged,
    int min = 0,
    int max = 100,
    int step = 1,
  }) {
    return NeoNumberSelectorVertical(
      key: key,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      step: step,
    );
  }

  /// Creates a pill-shaped compact number selector.
  static Widget compact({
    Key? key,
    required int value,
    required ValueChanged<int> onChanged,
    int min = 0,
    int max = 100,
    int step = 1,
  }) {
    return NeoNumberSelectorCompact(
      key: key,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      step: step,
    );
  }

  /// Creates a large prominent number selector with gradient value display.
  static Widget prominent({
    Key? key,
    required int value,
    required ValueChanged<int> onChanged,
    int min = 0,
    int max = 100,
    int step = 1,
    String? label,
    String? unit,
  }) {
    return NeoNumberSelectorProminent(
      key: key,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      step: step,
      label: label,
      unit: unit,
    );
  }
}
