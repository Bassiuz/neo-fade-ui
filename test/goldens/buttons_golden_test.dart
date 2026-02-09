import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import '../helpers/golden_test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpGoldenTests();
  });

  group('NeoButtonFilled Goldens', () {
    testWidgets('default state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoButtonFilled(label: 'Button', onPressed: () {}),
        size: GoldenTestSizes.button,
      );
      await expectLater(
        find.byType(NeoButtonFilled),
        matchesGoldenFile('neo_button_1_default.png'),
      );
    });

    testWidgets('with icon', (tester) async {
      await tester.pumpGoldenWidget(
        NeoButtonFilled(
          label: 'Button',
          icon: Icons.star,
          onPressed: () {},
        ),
        size: GoldenTestSizes.button,
      );
      await expectLater(
        find.byType(NeoButtonFilled),
        matchesGoldenFile('neo_button_1_with_icon.png'),
      );
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoButtonFilled(label: 'Button', onPressed: null),
        size: GoldenTestSizes.button,
      );
      await expectLater(
        find.byType(NeoButtonFilled),
        matchesGoldenFile('neo_button_1_disabled.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        NeoButtonFilled(label: 'Button', onPressed: () {}),
        size: GoldenTestSizes.button,
        isDark: true,
      );
      await expectLater(
        find.byType(NeoButtonFilled),
        matchesGoldenFile('neo_button_1_dark.png'),
      );
    });
  });

  group('NeoButtonGradientBorder Goldens', () {
    testWidgets('default state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoButtonGradientBorder(label: 'Button', onPressed: () {}),
        size: GoldenTestSizes.button,
      );
      await expectLater(
        find.byType(NeoButtonGradientBorder),
        matchesGoldenFile('neo_button_2_default.png'),
      );
    });

    testWidgets('with icon', (tester) async {
      await tester.pumpGoldenWidget(
        NeoButtonGradientBorder(
          label: 'Button',
          icon: Icons.star,
          onPressed: () {},
        ),
        size: GoldenTestSizes.button,
      );
      await expectLater(
        find.byType(NeoButtonGradientBorder),
        matchesGoldenFile('neo_button_2_with_icon.png'),
      );
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoButtonGradientBorder(label: 'Button', onPressed: null),
        size: GoldenTestSizes.button,
      );
      await expectLater(
        find.byType(NeoButtonGradientBorder),
        matchesGoldenFile('neo_button_2_disabled.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        NeoButtonGradientBorder(label: 'Button', onPressed: () {}),
        size: GoldenTestSizes.button,
        isDark: true,
      );
      await expectLater(
        find.byType(NeoButtonGradientBorder),
        matchesGoldenFile('neo_button_2_dark.png'),
      );
    });
  });
}
