import 'dart:ui';

class NeoFadeGlassProperties {
  final double blur;
  final double tintOpacity;
  final double borderOpacity;
  final double innerBorderWidth;
  final double shadowOpacity;

  const NeoFadeGlassProperties({
    required this.blur,
    required this.tintOpacity,
    required this.borderOpacity,
    required this.innerBorderWidth,
    required this.shadowOpacity,
  });

  factory NeoFadeGlassProperties.light() {
    return const NeoFadeGlassProperties(
      blur: 20.0,
      tintOpacity: 0.7,
      borderOpacity: 0.5,
      innerBorderWidth: 1.0,
      shadowOpacity: 0.1,
    );
  }

  factory NeoFadeGlassProperties.dark() {
    return const NeoFadeGlassProperties(
      blur: 25.0,
      tintOpacity: 0.6,
      borderOpacity: 0.15,
      innerBorderWidth: 1.0,
      shadowOpacity: 0.3,
    );
  }

  factory NeoFadeGlassProperties.forBrightness(Brightness brightness) {
    return brightness == Brightness.light
        ? NeoFadeGlassProperties.light()
        : NeoFadeGlassProperties.dark();
  }

  NeoFadeGlassProperties copyWith({
    double? blur,
    double? tintOpacity,
    double? borderOpacity,
    double? innerBorderWidth,
    double? shadowOpacity,
  }) {
    return NeoFadeGlassProperties(
      blur: blur ?? this.blur,
      tintOpacity: tintOpacity ?? this.tintOpacity,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      innerBorderWidth: innerBorderWidth ?? this.innerBorderWidth,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
    );
  }
}
