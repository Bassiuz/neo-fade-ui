import 'dart:ui';

import 'neo_fade_colors.dart';
import 'neo_fade_typography.dart';
import 'neo_fade_glass_properties.dart';

class NeoFadeThemeData {
  final NeoFadeColors colors;
  final NeoFadeTypography typography;
  final NeoFadeGlassProperties glass;

  const NeoFadeThemeData({
    required this.colors,
    required this.typography,
    required this.glass,
  });

  factory NeoFadeThemeData.fromColors({
    required Color primary,
    required Color secondary,
    Color? tertiary,
    required Brightness brightness,
  }) {
    final colors = NeoFadeColors.fromSeed(
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      brightness: brightness,
    );

    return NeoFadeThemeData(
      colors: colors,
      typography: NeoFadeTypography.fromColor(colors.onSurface),
      glass: NeoFadeGlassProperties.forBrightness(brightness),
    );
  }

  factory NeoFadeThemeData.light({
    required Color primary,
    required Color secondary,
    Color? tertiary,
  }) {
    return NeoFadeThemeData.fromColors(
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      brightness: Brightness.light,
    );
  }

  factory NeoFadeThemeData.dark({
    required Color primary,
    required Color secondary,
    Color? tertiary,
  }) {
    return NeoFadeThemeData.fromColors(
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      brightness: Brightness.dark,
    );
  }

  bool get isLight => colors.isLight;
  bool get isDark => colors.isDark;
  Brightness get brightness => colors.brightness;

  NeoFadeThemeData copyWith({
    NeoFadeColors? colors,
    NeoFadeTypography? typography,
    NeoFadeGlassProperties? glass,
  }) {
    return NeoFadeThemeData(
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      glass: glass ?? this.glass,
    );
  }
}
