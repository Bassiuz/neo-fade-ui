import 'dart:ui';

import '../utils/color_utils.dart';

class NeoFadeColors {
  final Color primary;
  final Color secondary;
  final Color tertiary;

  final Color primaryHover;
  final Color primaryPressed;
  final Color secondaryHover;
  final Color secondaryPressed;

  final Color surface;
  final Color surfaceTint;
  final Color surfaceVariant;

  final Color onPrimary;
  final Color onSecondary;
  final Color onSurface;
  final Color onSurfaceVariant;

  final Color border;
  final Color borderSubtle;
  final Color borderFocus;

  final Color error;
  final Color success;
  final Color warning;

  final Color disabled;
  final Color disabledText;

  final Brightness brightness;

  const NeoFadeColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.primaryHover,
    required this.primaryPressed,
    required this.secondaryHover,
    required this.secondaryPressed,
    required this.surface,
    required this.surfaceTint,
    required this.surfaceVariant,
    required this.onPrimary,
    required this.onSecondary,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.border,
    required this.borderSubtle,
    required this.borderFocus,
    required this.error,
    required this.success,
    required this.warning,
    required this.disabled,
    required this.disabledText,
    required this.brightness,
  });

  factory NeoFadeColors.fromSeed({
    required Color primary,
    required Color secondary,
    Color? tertiary,
    required Brightness brightness,
  }) {
    final effectiveTertiary = tertiary ?? ColorUtils.generateComplementary(primary);

    if (brightness == Brightness.light) {
      return NeoFadeColors._generateLight(
        primary: primary,
        secondary: secondary,
        tertiary: effectiveTertiary,
      );
    } else {
      return NeoFadeColors._generateDark(
        primary: primary,
        secondary: secondary,
        tertiary: effectiveTertiary,
      );
    }
  }

  factory NeoFadeColors._generateLight({
    required Color primary,
    required Color secondary,
    required Color tertiary,
  }) {
    return NeoFadeColors(
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      primaryHover: ColorUtils.lighten(primary, 0.1),
      primaryPressed: ColorUtils.darken(primary, 0.1),
      secondaryHover: ColorUtils.lighten(secondary, 0.1),
      secondaryPressed: ColorUtils.darken(secondary, 0.1),
      surface: const Color(0xFFF8FAFC),
      surfaceTint: ColorUtils.adjustOpacity(primary, 0.08),
      surfaceVariant: const Color(0xFFE2E8F0),
      onPrimary: ColorUtils.contrastingTextColor(primary),
      onSecondary: ColorUtils.contrastingTextColor(secondary),
      onSurface: const Color(0xFF0F172A),
      onSurfaceVariant: const Color(0xFF475569),
      border: const Color(0xFFCBD5E1),
      borderSubtle: const Color(0xFFE2E8F0),
      borderFocus: ColorUtils.adjustOpacity(primary, 0.5),
      error: const Color(0xFFEF4444),
      success: const Color(0xFF22C55E),
      warning: const Color(0xFFF59E0B),
      disabled: const Color(0xFFE2E8F0),
      disabledText: const Color(0xFF94A3B8),
      brightness: Brightness.light,
    );
  }

  factory NeoFadeColors._generateDark({
    required Color primary,
    required Color secondary,
    required Color tertiary,
  }) {
    return NeoFadeColors(
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      primaryHover: ColorUtils.lighten(primary, 0.15),
      primaryPressed: ColorUtils.darken(primary, 0.1),
      secondaryHover: ColorUtils.lighten(secondary, 0.15),
      secondaryPressed: ColorUtils.darken(secondary, 0.1),
      surface: const Color(0xFF0F172A),
      surfaceTint: ColorUtils.adjustOpacity(primary, 0.12),
      surfaceVariant: const Color(0xFF1E293B),
      onPrimary: ColorUtils.contrastingTextColor(primary),
      onSecondary: ColorUtils.contrastingTextColor(secondary),
      onSurface: const Color(0xFFF1F5F9),
      onSurfaceVariant: const Color(0xFF94A3B8),
      border: const Color(0xFF334155),
      borderSubtle: const Color(0xFF1E293B),
      borderFocus: ColorUtils.adjustOpacity(primary, 0.6),
      error: const Color(0xFFF87171),
      success: const Color(0xFF4ADE80),
      warning: const Color(0xFFFBBF24),
      disabled: const Color(0xFF1E293B),
      disabledText: const Color(0xFF475569),
      brightness: Brightness.dark,
    );
  }

  bool get isLight => brightness == Brightness.light;
  bool get isDark => brightness == Brightness.dark;

  NeoFadeColors copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? primaryHover,
    Color? primaryPressed,
    Color? secondaryHover,
    Color? secondaryPressed,
    Color? surface,
    Color? surfaceTint,
    Color? surfaceVariant,
    Color? onPrimary,
    Color? onSecondary,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? border,
    Color? borderSubtle,
    Color? borderFocus,
    Color? error,
    Color? success,
    Color? warning,
    Color? disabled,
    Color? disabledText,
    Brightness? brightness,
  }) {
    return NeoFadeColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      primaryHover: primaryHover ?? this.primaryHover,
      primaryPressed: primaryPressed ?? this.primaryPressed,
      secondaryHover: secondaryHover ?? this.secondaryHover,
      secondaryPressed: secondaryPressed ?? this.secondaryPressed,
      surface: surface ?? this.surface,
      surfaceTint: surfaceTint ?? this.surfaceTint,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      onPrimary: onPrimary ?? this.onPrimary,
      onSecondary: onSecondary ?? this.onSecondary,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      border: border ?? this.border,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderFocus: borderFocus ?? this.borderFocus,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      disabled: disabled ?? this.disabled,
      disabledText: disabledText ?? this.disabledText,
      brightness: brightness ?? this.brightness,
    );
  }
}
