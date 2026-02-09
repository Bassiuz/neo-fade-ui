import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// Default colors for golden tests.
class GoldenTestColors {
  static const primary = Color(0xFF6366F1);
  static const secondary = Color(0xFF8B5CF6);
}

/// Sets up the golden test environment.
/// Call this in setUpAll() for each test file.
Future<void> setUpGoldenTests() async {
  TestWidgetsFlutterBinding.ensureInitialized();
}

/// Creates a test typography that uses system fonts instead of Google Fonts.
/// This avoids network requests during tests.
NeoFadeTypography createTestTypography(Color textColor) {
  const baseStyle = TextStyle(
    fontFamily: 'Roboto',
    package: null,
  );

  return NeoFadeTypography(
    displayLarge: baseStyle.copyWith(
      fontSize: 57,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
      height: 1.12,
      color: textColor,
    ),
    displayMedium: baseStyle.copyWith(
      fontSize: 45,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.25,
      height: 1.16,
      color: textColor,
    ),
    displaySmall: baseStyle.copyWith(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
      color: textColor,
    ),
    headlineLarge: baseStyle.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.25,
      height: 1.25,
      color: textColor,
    ),
    headlineMedium: baseStyle.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.29,
      color: textColor,
    ),
    headlineSmall: baseStyle.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.33,
      color: textColor,
    ),
    titleLarge: baseStyle.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.27,
      color: textColor,
    ),
    titleMedium: baseStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.5,
      color: textColor,
    ),
    titleSmall: baseStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
      color: textColor,
    ),
    bodyLarge: baseStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.5,
      color: textColor,
    ),
    bodyMedium: baseStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      height: 1.43,
      color: textColor,
    ),
    bodySmall: baseStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.33,
      color: textColor,
    ),
    labelLarge: baseStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
      color: textColor,
    ),
    labelMedium: baseStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
      height: 1.33,
      color: textColor,
    ),
    labelSmall: baseStyle.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
      height: 1.45,
      color: textColor,
    ),
  );
}

/// Creates test theme data with system fonts instead of Google Fonts.
NeoFadeThemeData createTestThemeData({bool isDark = false}) {
  final colors = NeoFadeColors.fromSeed(
    primary: GoldenTestColors.primary,
    secondary: GoldenTestColors.secondary,
    brightness: isDark ? Brightness.dark : Brightness.light,
  );

  return NeoFadeThemeData(
    colors: colors,
    typography: createTestTypography(colors.onSurface),
    glass: NeoFadeGlassProperties.forBrightness(
      isDark ? Brightness.dark : Brightness.light,
    ),
  );
}

/// Wraps a widget in NeoFadeTheme for golden testing.
Widget goldenTestWrapper(
  Widget child, {
  bool isDark = false,
  Size size = const Size(400, 300),
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NeoFadeTheme(
      data: createTestThemeData(isDark: isDark),
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        body: Center(child: child),
      ),
    ),
  );
}

/// Extension to simplify golden test creation.
extension GoldenTestExtension on WidgetTester {
  Future<void> pumpGoldenWidget(
    Widget widget, {
    bool isDark = false,
    Size size = const Size(400, 300),
  }) async {
    await binding.setSurfaceSize(size);
    await pumpWidget(goldenTestWrapper(widget, isDark: isDark, size: size));
    await pumpAndSettle();
  }
}

/// Common sizes for golden tests.
class GoldenTestSizes {
  static const button = Size(200, 60);
  static const card = Size(350, 200);
  static const input = Size(300, 80);
  static const navigation = Size(400, 100);
  static const selector = Size(350, 60);
  static const chip = Size(150, 50);
  static const avatar = Size(100, 100);
  static const progress = Size(300, 50);
}
