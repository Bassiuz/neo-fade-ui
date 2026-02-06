import 'package:flutter/widgets.dart';

import 'neo_switch_glass.dart';
import 'neo_switch_ios.dart';
import 'neo_switch_pill.dart';
import 'neo_switch_glow.dart';
import 'neo_switch_minimal.dart';
import 'neo_switch_ripple.dart';
import 'neo_switch_bouncy.dart';
import 'neo_switch_pulse.dart';

/// NeoSwitch provides factory constructors for all switch variants.
///
/// Available variants:
/// - [NeoSwitch.glass] - Glass track with gradient thumb, slides smoothly
/// - [NeoSwitch.ios] - iOS-style glass switch with gradient fill when on
/// - [NeoSwitch.pill] - Pill switch with gradient track animation on toggle
/// - [NeoSwitch.glow] - Glass switch with glowing gradient thumb
/// - [NeoSwitch.minimal] - Minimal switch with gradient line indicator
/// - [NeoSwitch.ripple] - Switch with gradient expanding from thumb on toggle
/// - [NeoSwitch.bouncy] - Glass switch with bouncy thumb animation
/// - [NeoSwitch.pulse] - Switch with gradient pulse effect when toggled
abstract class NeoSwitch extends StatefulWidget {
  /// The current value of the switch.
  final bool value;

  /// Called when the user toggles the switch.
  final ValueChanged<bool>? onChanged;

  /// Whether the switch is enabled.
  final bool enabled;

  const NeoSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  /// Glass track with gradient thumb, slides smoothly.
  ///
  /// Features a frosted glass track with a vibrant gradient thumb
  /// that slides smoothly between on/off positions.
  static Widget glass({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    bool enabled = true,
  }) {
    return NeoSwitchGlass(
      key: key,
      value: value,
      onChanged: onChanged,
      enabled: enabled,
    );
  }

  /// iOS-style glass switch with gradient fill when on.
  ///
  /// An iOS-inspired switch with a frosted glass appearance that fills
  /// with a vibrant gradient when toggled on.
  static Widget ios({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    bool enabled = true,
  }) {
    return NeoSwitchIos(
      key: key,
      value: value,
      onChanged: onChanged,
      enabled: enabled,
    );
  }

  /// Pill switch with gradient track animation on toggle.
  ///
  /// A pill-shaped switch where the entire track animates to a vibrant
  /// gradient when toggled on.
  static Widget pill({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    bool enabled = true,
  }) {
    return NeoSwitchPill(
      key: key,
      value: value,
      onChanged: onChanged,
      enabled: enabled,
    );
  }

  /// Glass switch with glowing gradient thumb.
  ///
  /// Features a subtle glass track with a thumb that glows with
  /// a vibrant gradient when the switch is on.
  static Widget glow({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    bool enabled = true,
  }) {
    return NeoSwitchGlow(
      key: key,
      value: value,
      onChanged: onChanged,
      enabled: enabled,
    );
  }

  /// Minimal switch with gradient line indicator.
  ///
  /// A minimalist design featuring a thin gradient line that appears
  /// beneath the track when toggled on.
  static Widget minimal({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    bool enabled = true,
  }) {
    return NeoSwitchMinimal(
      key: key,
      value: value,
      onChanged: onChanged,
      enabled: enabled,
    );
  }

  /// Switch with gradient expanding from thumb on toggle.
  ///
  /// A switch where the gradient appears to expand outward from the thumb
  /// position when toggled on, creating a ripple-like effect.
  static Widget ripple({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    bool enabled = true,
  }) {
    return NeoSwitchRipple(
      key: key,
      value: value,
      onChanged: onChanged,
      enabled: enabled,
    );
  }

  /// Glass switch with bouncy thumb animation.
  ///
  /// A playful switch with a glass track where the thumb bounces
  /// elastically when toggled.
  static Widget bouncy({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    bool enabled = true,
  }) {
    return NeoSwitchBouncy(
      key: key,
      value: value,
      onChanged: onChanged,
      enabled: enabled,
    );
  }

  /// Switch with gradient pulse effect when toggled.
  ///
  /// A switch that pulses with a gradient ring effect when toggled,
  /// providing satisfying visual feedback.
  static Widget pulse({
    Key? key,
    required bool value,
    ValueChanged<bool>? onChanged,
    bool enabled = true,
  }) {
    return NeoSwitchPulse(
      key: key,
      value: value,
      onChanged: onChanged,
      enabled: enabled,
    );
  }
}
