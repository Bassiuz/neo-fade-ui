import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import '../helpers/golden_test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpGoldenTests();
  });

  group('NeoButton1 Goldens', () {
    testWidgets('default state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoButton1(label: 'Button', onPressed: () {}),
        size: GoldenTestSizes.button,
      );
      await expectLater(
        find.byType(NeoButton1),
        matchesGoldenFile('neo_button_1_default.png'),
      );
    });

    testWidgets('with icon', (tester) async {
      await tester.pumpGoldenWidget(
        NeoButton1(
          label: 'Button',
          icon: Icons.star,
          onPressed: () {},
        ),
        size: GoldenTestSizes.button,
      );
      await expectLater(
        find.byType(NeoButton1),
        matchesGoldenFile('neo_button_1_with_icon.png'),
      );
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoButton1(label: 'Button', onPressed: null),
        size: GoldenTestSizes.button,
      );
      await expectLater(
        find.byType(NeoButton1),
        matchesGoldenFile('neo_button_1_disabled.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        NeoButton1(label: 'Button', onPressed: () {}),
        size: GoldenTestSizes.button,
        isDark: true,
      );
      await expectLater(
        find.byType(NeoButton1),
        matchesGoldenFile('neo_button_1_dark.png'),
      );
    });
  });

  group('NeoButton2 Goldens', () {
    testWidgets('default state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoButton2(label: 'Button', onPressed: () {}),
        size: GoldenTestSizes.button,
      );
      await expectLater(
        find.byType(NeoButton2),
        matchesGoldenFile('neo_button_2_default.png'),
      );
    });

    testWidgets('with icon', (tester) async {
      await tester.pumpGoldenWidget(
        NeoButton2(
          label: 'Button',
          icon: Icons.star,
          onPressed: () {},
        ),
        size: GoldenTestSizes.button,
      );
      await expectLater(
        find.byType(NeoButton2),
        matchesGoldenFile('neo_button_2_with_icon.png'),
      );
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoButton2(label: 'Button', onPressed: null),
        size: GoldenTestSizes.button,
      );
      await expectLater(
        find.byType(NeoButton2),
        matchesGoldenFile('neo_button_2_disabled.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        NeoButton2(label: 'Button', onPressed: () {}),
        size: GoldenTestSizes.button,
        isDark: true,
      );
      await expectLater(
        find.byType(NeoButton2),
        matchesGoldenFile('neo_button_2_dark.png'),
      );
    });
  });
}
