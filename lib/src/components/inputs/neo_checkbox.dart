import 'package:flutter/widgets.dart';

import 'neo_checkbox_glass.dart';
import 'neo_checkbox_fill_scale.dart';
import 'neo_checkbox_ring.dart';
import 'neo_checkbox_glow_border.dart';
import 'neo_checkbox_sweep.dart';
import 'neo_checkbox_minimal.dart';
import 'neo_checkbox_bouncy.dart';
import 'neo_checkbox_pulse.dart';

/// A collection of animated checkbox variants with various visual styles.
///
/// Use the named constructors to create different checkbox styles:
/// - [NeoCheckbox.glass] - Glass with gradient checkmark
/// - [NeoCheckbox.fillScale] - Scales/fills from center
/// - [NeoCheckbox.ring] - Circular with ring sweep
/// - [NeoCheckbox.glowBorder] - Glowing gradient border
/// - [NeoCheckbox.sweep] - Pie-slice fill animation
/// - [NeoCheckbox.minimal] - Only checkmark visible
/// - [NeoCheckbox.bouncy] - Bouncy gradient fill
/// - [NeoCheckbox.pulse] - Pulsing glow shadow
abstract class NeoCheckbox extends StatefulWidget {
  /// The current value of the checkbox.
  final bool value;

  /// Called when the value should change.
  final ValueChanged<bool>? onChanged;

  /// Optional label displayed next to the checkbox.
  final String? label;

  /// The size of the checkbox.
  final double size;

  const NeoCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.size = 24.0,
  });

  /// Glass square checkbox with gradient checkmark and scale animation.
  ///
  /// A poppy, colorful checkbox with tinted glass effect. The checkmark
  /// appears with a vibrant gradient and smooth scale animation on check.
  static Widget glass({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    String? label,
    double size = 24.0,
  }) {
    return NeoCheckboxGlass(
      key: key,
      value: value,
      onChanged: onChanged,
      label: label,
      size: size,
    );
  }

  /// Rounded glass checkbox with gradient fill when checked.
  ///
  /// Features a soft rounded rectangle that fills with a vibrant gradient
  /// when checked, with a white checkmark appearing on top.
  static Widget fillScale({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    String? label,
    double size = 24.0,
  }) {
    return NeoCheckboxFillScale(
      key: key,
      value: value,
      onChanged: onChanged,
      label: label,
      size: size,
    );
  }

  /// Circular checkbox with gradient ring that fills inward.
  ///
  /// A circular glass checkbox featuring a vibrant gradient ring that
  /// animates inward when checked, revealing a centered dot.
  static Widget ring({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    String? label,
    double size = 24.0,
  }) {
    return NeoCheckboxRing(
      key: key,
      value: value,
      onChanged: onChanged,
      label: label,
      size: size,
    );
  }

  /// Glass checkbox with gradient border glow on check.
  ///
  /// A glass checkbox that reveals a vibrant glowing gradient border
  /// when checked, with a subtle checkmark inside.
  static Widget glowBorder({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    String? label,
    double size = 24.0,
  }) {
    return NeoCheckboxGlowBorder(
      key: key,
      value: value,
      onChanged: onChanged,
      label: label,
      size: size,
    );
  }

  /// Checkbox with animated gradient sweep on check.
  ///
  /// A glass checkbox featuring a dramatic gradient sweep animation that
  /// rotates through the checkbox when checked, leaving a vibrant fill.
  static Widget sweep({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    String? label,
    double size = 24.0,
  }) {
    return NeoCheckboxSweep(
      key: key,
      value: value,
      onChanged: onChanged,
      label: label,
      size: size,
    );
  }

  /// Minimal checkbox where just the gradient checkmark appears.
  ///
  /// A minimalist design with a subtle glass container where only
  /// a vibrant gradient checkmark animates in when checked.
  static Widget minimal({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    String? label,
    double size = 24.0,
  }) {
    return NeoCheckboxMinimal(
      key: key,
      value: value,
      onChanged: onChanged,
      label: label,
      size: size,
    );
  }

  /// Glass checkbox with bouncy check animation.
  ///
  /// A playful glass checkbox with an elastic, bouncy animation when
  /// the checkmark appears, using spring physics for a lively feel.
  static Widget bouncy({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    String? label,
    double size = 24.0,
  }) {
    return NeoCheckboxBouncy(
      key: key,
      value: value,
      onChanged: onChanged,
      label: label,
      size: size,
    );
  }

  /// Checkbox with gradient shadow pulse when checked.
  ///
  /// A glass checkbox that emits a pulsing gradient shadow effect
  /// when checked, creating a glowing, vibrant appearance.
  static Widget pulse({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    String? label,
    double size = 24.0,
  }) {
    return NeoCheckboxPulse(
      key: key,
      value: value,
      onChanged: onChanged,
      label: label,
      size: size,
    );
  }
}
