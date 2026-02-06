import 'package:flutter/widgets.dart';

import 'neo_text_field_corner_badges.dart';
import 'neo_text_field_floating_label.dart';
import 'neo_text_field_left_accent.dart';
import 'neo_text_field_minimal.dart';
import 'neo_text_field_outlined.dart';
import 'neo_text_field_pill.dart';
import 'neo_text_field_shimmer.dart';
import 'neo_text_field_underline.dart';

/// A collection of styled text field variants for the Neo Fade UI design system.
///
/// Use the named constructors to create different text field styles:
/// - [NeoTextField.underline] - Glass with gradient underline
/// - [NeoTextField.outlined] - Full gradient border on focus
/// - [NeoTextField.leftAccent] - Left-side gradient bar
/// - [NeoTextField.minimal] - Only underline, no glass
/// - [NeoTextField.floatingLabel] - Floating label with glow
/// - [NeoTextField.pill] - Pill-shaped with outline
/// - [NeoTextField.shimmer] - Shimmer cursor effect
/// - [NeoTextField.cornerBadges] - Corner gradient badges
abstract class NeoTextField extends StatefulWidget {
  const NeoTextField._();

  /// Glass container text field with gradient underline that animates on focus.
  ///
  /// Features a tinted glass background with a vibrant gradient underline
  /// that becomes visible and animates when the field receives focus.
  static Widget underline({
    Key? key,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    String? hintText,
    String? labelText,
    bool enabled = true,
    bool obscureText = false,
    TextInputType? keyboardType,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return NeoTextFieldUnderline(
      key: key,
      controller: controller,
      onChanged: onChanged,
      hintText: hintText,
      labelText: labelText,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// Outlined glass field with gradient border on focus.
  ///
  /// Features a subtle glass background with a full gradient border
  /// that animates in from transparent when the field receives focus.
  static Widget outlined({
    Key? key,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    String? hintText,
    String? labelText,
    bool enabled = true,
    bool obscureText = false,
    TextInputType? keyboardType,
    FocusNode? focusNode,
    bool autofocus = false,
    double? borderRadius,
    double? borderWidth,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? hintStyle,
  }) {
    return NeoTextFieldOutlined(
      key: key,
      controller: controller,
      onChanged: onChanged,
      hintText: hintText,
      labelText: labelText,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      autofocus: autofocus,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      contentPadding: contentPadding,
      hintStyle: hintStyle,
    );
  }

  /// Filled glass field with gradient accent on the left edge.
  ///
  /// Features a filled glass background with a vibrant gradient bar
  /// on the left side that becomes more prominent when focused.
  static Widget leftAccent({
    Key? key,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    String? hintText,
    String? labelText,
    bool enabled = true,
    bool obscureText = false,
    TextInputType? keyboardType,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return NeoTextFieldLeftAccent(
      key: key,
      controller: controller,
      onChanged: onChanged,
      hintText: hintText,
      labelText: labelText,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// Minimal underline text field with gradient color on focus.
  ///
  /// A clean, minimal design featuring only an underline that transforms
  /// from a subtle border to a vibrant gradient when the field receives focus.
  static Widget minimal({
    Key? key,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    String? hintText,
    String? labelText,
    bool enabled = true,
    bool obscureText = false,
    TextInputType? keyboardType,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return NeoTextFieldMinimal(
      key: key,
      controller: controller,
      onChanged: onChanged,
      hintText: hintText,
      labelText: labelText,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// Glass field with floating label and gradient glow on focus.
  ///
  /// Features a tinted glass background with a floating label that
  /// animates up when focused or has content. A gradient glow appears
  /// around the field when focused.
  static Widget floatingLabel({
    Key? key,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    String? hintText,
    required String labelText,
    bool enabled = true,
    bool obscureText = false,
    TextInputType? keyboardType,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return NeoTextFieldFloatingLabel(
      key: key,
      controller: controller,
      onChanged: onChanged,
      hintText: hintText,
      labelText: labelText,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// Rounded pill shape glass field with gradient outline.
  ///
  /// Features a fully rounded pill-shaped glass container with a
  /// gradient outline that becomes visible when the field is focused.
  static Widget pill({
    Key? key,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    String? hintText,
    String? labelText,
    bool enabled = true,
    bool obscureText = false,
    TextInputType? keyboardType,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return NeoTextFieldPill(
      key: key,
      controller: controller,
      onChanged: onChanged,
      hintText: hintText,
      labelText: labelText,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// Glass field with gradient shimmer cursor line.
  ///
  /// Features a tinted glass background with a unique animated gradient
  /// shimmer effect that follows the cursor position when focused.
  static Widget shimmer({
    Key? key,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    String? hintText,
    String? labelText,
    bool enabled = true,
    bool obscureText = false,
    TextInputType? keyboardType,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return NeoTextFieldShimmer(
      key: key,
      controller: controller,
      onChanged: onChanged,
      hintText: hintText,
      labelText: labelText,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// Glass field with corner gradient accent badges.
  ///
  /// Features a tinted glass background with vibrant gradient badges
  /// in the corners that become visible and animate when focused.
  static Widget cornerBadges({
    Key? key,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    String? hintText,
    String? labelText,
    bool enabled = true,
    bool obscureText = false,
    TextInputType? keyboardType,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return NeoTextFieldCornerBadges(
      key: key,
      controller: controller,
      onChanged: onChanged,
      hintText: hintText,
      labelText: labelText,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }
}
