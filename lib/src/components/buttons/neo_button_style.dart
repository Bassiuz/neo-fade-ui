import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_colors.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import 'neo_button_size.dart';
import 'neo_button_variant.dart';

class NeoButtonStyle {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? blur;
  final double? tintOpacity;
  final double? innerBorderOpacity;

  const NeoButtonStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.blur,
    this.tintOpacity,
    this.innerBorderOpacity,
  });

  static EdgeInsetsGeometry paddingForSize(NeoButtonSize size) {
    switch (size) {
      case NeoButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: NeoFadeSpacing.md,
          vertical: NeoFadeSpacing.xs,
        );
      case NeoButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: NeoFadeSpacing.lg,
          vertical: NeoFadeSpacing.sm,
        );
      case NeoButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: NeoFadeSpacing.xl,
          vertical: NeoFadeSpacing.md,
        );
    }
  }

  static double fontSizeForSize(NeoButtonSize size) {
    switch (size) {
      case NeoButtonSize.small:
        return 12;
      case NeoButtonSize.medium:
        return 14;
      case NeoButtonSize.large:
        return 16;
    }
  }

  static NeoButtonStyle resolveStyle({
    required NeoButtonVariant variant,
    required NeoButtonSize size,
    required NeoFadeColors colors,
    NeoButtonStyle? style,
  }) {
    final basePadding = paddingForSize(size);

    switch (variant) {
      case NeoButtonVariant.filled:
        return NeoButtonStyle(
          backgroundColor: style?.backgroundColor ?? colors.primary,
          foregroundColor: style?.foregroundColor ?? colors.onPrimary,
          borderColor: style?.borderColor,
          borderWidth: style?.borderWidth ?? 0,
          borderRadius: style?.borderRadius ?? NeoFadeRadii.mdRadius,
          padding: style?.padding ?? basePadding,
          blur: style?.blur ?? 10,
          tintOpacity: style?.tintOpacity ?? 0.9,
          innerBorderOpacity: style?.innerBorderOpacity ?? 0.3,
        );
      case NeoButtonVariant.outlined:
        return NeoButtonStyle(
          backgroundColor: style?.backgroundColor ?? colors.surface,
          foregroundColor: style?.foregroundColor ?? colors.primary,
          borderColor: style?.borderColor ?? colors.primary,
          borderWidth: style?.borderWidth ?? 1.5,
          borderRadius: style?.borderRadius ?? NeoFadeRadii.mdRadius,
          padding: style?.padding ?? basePadding,
          blur: style?.blur ?? 15,
          tintOpacity: style?.tintOpacity ?? 0.3,
          innerBorderOpacity: style?.innerBorderOpacity ?? 0.2,
        );
      case NeoButtonVariant.ghost:
        return NeoButtonStyle(
          backgroundColor: style?.backgroundColor ?? colors.surface,
          foregroundColor: style?.foregroundColor ?? colors.onSurface,
          borderColor: style?.borderColor,
          borderWidth: style?.borderWidth ?? 0,
          borderRadius: style?.borderRadius ?? NeoFadeRadii.mdRadius,
          padding: style?.padding ?? basePadding,
          blur: style?.blur ?? 10,
          tintOpacity: style?.tintOpacity ?? 0.1,
          innerBorderOpacity: style?.innerBorderOpacity ?? 0.1,
        );
    }
  }

  NeoButtonStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    double? blur,
    double? tintOpacity,
    double? innerBorderOpacity,
  }) {
    return NeoButtonStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      blur: blur ?? this.blur,
      tintOpacity: tintOpacity ?? this.tintOpacity,
      innerBorderOpacity: innerBorderOpacity ?? this.innerBorderOpacity,
    );
  }
}
