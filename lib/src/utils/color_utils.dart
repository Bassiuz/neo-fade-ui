import 'package:flutter/painting.dart';

class ColorUtils {
  const ColorUtils._();

  static Color darken(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }

  static Color lighten(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightened = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lightened.toColor();
  }

  static Color saturate(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final saturated = hsl.withSaturation((hsl.saturation + amount).clamp(0.0, 1.0));
    return saturated.toColor();
  }

  static Color desaturate(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final desaturated = hsl.withSaturation((hsl.saturation - amount).clamp(0.0, 1.0));
    return desaturated.toColor();
  }

  static Color adjustOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  static Color blend(Color color1, Color color2, double amount) {
    return Color.lerp(color1, color2, amount)!;
  }

  static double luminance(Color color) {
    return color.computeLuminance();
  }

  static bool isLight(Color color) {
    return luminance(color) > 0.5;
  }

  static bool isDark(Color color) {
    return !isLight(color);
  }

  static Color contrastingTextColor(Color background) {
    return isLight(background)
        ? const Color(0xFF000000)
        : const Color(0xFFFFFFFF);
  }

  static Color generateComplementary(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withHue((hsl.hue + 180) % 360).toColor();
  }

  static List<Color> generateAnalogous(Color color, {double spread = 30}) {
    final hsl = HSLColor.fromColor(color);
    return [
      hsl.withHue((hsl.hue - spread) % 360).toColor(),
      color,
      hsl.withHue((hsl.hue + spread) % 360).toColor(),
    ];
  }

  static List<Color> generateTriadic(Color color) {
    final hsl = HSLColor.fromColor(color);
    return [
      color,
      hsl.withHue((hsl.hue + 120) % 360).toColor(),
      hsl.withHue((hsl.hue + 240) % 360).toColor(),
    ];
  }
}
