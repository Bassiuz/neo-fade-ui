import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import '../helpers/golden_test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpGoldenTests();
  });

  group('NeoTextField2 Goldens', () {
    testWidgets('default state', (tester) async {
      await tester.pumpGoldenWidget(
        const SizedBox(
          width: 280,
          child: NeoTextField2(
            hintText: 'Enter text...',
          ),
        ),
        size: GoldenTestSizes.input,
      );
      await expectLater(
        find.byType(NeoTextField2),
        matchesGoldenFile('neo_text_field_2_default.png'),
      );
    });

    testWidgets('with label', (tester) async {
      await tester.pumpGoldenWidget(
        const SizedBox(
          width: 280,
          child: NeoTextField2(
            labelText: 'Email',
            hintText: 'Enter email...',
          ),
        ),
        size: const Size(300, 100),
      );
      await expectLater(
        find.byType(NeoTextField2),
        matchesGoldenFile('neo_text_field_2_with_label.png'),
      );
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpGoldenWidget(
        const SizedBox(
          width: 280,
          child: NeoTextField2(
            hintText: 'Enter text...',
            enabled: false,
          ),
        ),
        size: GoldenTestSizes.input,
      );
      await expectLater(
        find.byType(NeoTextField2),
        matchesGoldenFile('neo_text_field_2_disabled.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        const SizedBox(
          width: 280,
          child: NeoTextField2(
            hintText: 'Enter text...',
          ),
        ),
        size: GoldenTestSizes.input,
        isDark: true,
      );
      await expectLater(
        find.byType(NeoTextField2),
        matchesGoldenFile('neo_text_field_2_dark.png'),
      );
    });
  });

  group('NeoCheckbox4 Goldens', () {
    testWidgets('unchecked state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoCheckbox4(
          value: false,
          onChanged: (value) {},
        ),
        size: const Size(60, 60),
      );
      await expectLater(
        find.byType(NeoCheckbox4),
        matchesGoldenFile('neo_checkbox_4_unchecked.png'),
      );
    });

    testWidgets('checked state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoCheckbox4(
          value: true,
          onChanged: (value) {},
        ),
        size: const Size(60, 60),
      );
      await expectLater(
        find.byType(NeoCheckbox4),
        matchesGoldenFile('neo_checkbox_4_checked.png'),
      );
    });

    testWidgets('with label', (tester) async {
      await tester.pumpGoldenWidget(
        NeoCheckbox4(
          value: true,
          label: 'Accept terms',
          onChanged: (value) {},
        ),
        size: const Size(220, 60),
      );
      await expectLater(
        find.byType(NeoCheckbox4),
        matchesGoldenFile('neo_checkbox_4_with_label.png'),
      );
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoCheckbox4(
          value: false,
          onChanged: null,
        ),
        size: const Size(60, 60),
      );
      await expectLater(
        find.byType(NeoCheckbox4),
        matchesGoldenFile('neo_checkbox_4_disabled.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        NeoCheckbox4(
          value: true,
          onChanged: (value) {},
        ),
        size: const Size(60, 60),
        isDark: true,
      );
      await expectLater(
        find.byType(NeoCheckbox4),
        matchesGoldenFile('neo_checkbox_4_dark.png'),
      );
    });
  });

  group('NeoSwitch2 Goldens', () {
    testWidgets('off state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoSwitch2(
          value: false,
          onChanged: (value) {},
        ),
        size: const Size(80, 60),
      );
      await expectLater(
        find.byType(NeoSwitch2),
        matchesGoldenFile('neo_switch_2_off.png'),
      );
    });

    testWidgets('on state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoSwitch2(
          value: true,
          onChanged: (value) {},
        ),
        size: const Size(80, 60),
      );
      await expectLater(
        find.byType(NeoSwitch2),
        matchesGoldenFile('neo_switch_2_on.png'),
      );
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoSwitch2(
          value: false,
          enabled: false,
        ),
        size: const Size(80, 60),
      );
      await expectLater(
        find.byType(NeoSwitch2),
        matchesGoldenFile('neo_switch_2_disabled.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        NeoSwitch2(
          value: true,
          onChanged: (value) {},
        ),
        size: const Size(80, 60),
        isDark: true,
      );
      await expectLater(
        find.byType(NeoSwitch2),
        matchesGoldenFile('neo_switch_2_dark.png'),
      );
    });
  });

  group('NeoSlider Goldens', () {
    testWidgets('default state', (tester) async {
      await tester.pumpGoldenWidget(
        SizedBox(
          width: 280,
          child: NeoSlider(
            value: 0.5,
            onChanged: (value) {},
          ),
        ),
        size: const Size(300, 60),
      );
      await expectLater(
        find.byType(NeoSlider),
        matchesGoldenFile('neo_slider_default.png'),
      );
    });

    testWidgets('min value', (tester) async {
      await tester.pumpGoldenWidget(
        SizedBox(
          width: 280,
          child: NeoSlider(
            value: 0.0,
            onChanged: (value) {},
          ),
        ),
        size: const Size(300, 60),
      );
      await expectLater(
        find.byType(NeoSlider),
        matchesGoldenFile('neo_slider_min.png'),
      );
    });

    testWidgets('max value', (tester) async {
      await tester.pumpGoldenWidget(
        SizedBox(
          width: 280,
          child: NeoSlider(
            value: 1.0,
            onChanged: (value) {},
          ),
        ),
        size: const Size(300, 60),
      );
      await expectLater(
        find.byType(NeoSlider),
        matchesGoldenFile('neo_slider_max.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        SizedBox(
          width: 280,
          child: NeoSlider(
            value: 0.5,
            onChanged: (value) {},
          ),
        ),
        size: const Size(300, 60),
        isDark: true,
      );
      await expectLater(
        find.byType(NeoSlider),
        matchesGoldenFile('neo_slider_dark.png'),
      );
    });
  });

  group('NeoNumberSelector1 Goldens', () {
    testWidgets('default state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoNumberSelector1(
          value: 5,
          onChanged: (value) {},
        ),
        size: const Size(200, 80),
      );
      await expectLater(
        find.byType(NeoNumberSelector1),
        matchesGoldenFile('neo_number_selector_1_default.png'),
      );
    });

    testWidgets('at min value', (tester) async {
      await tester.pumpGoldenWidget(
        NeoNumberSelector1(
          value: 0,
          min: 0,
          onChanged: (value) {},
        ),
        size: const Size(200, 80),
      );
      await expectLater(
        find.byType(NeoNumberSelector1),
        matchesGoldenFile('neo_number_selector_1_min.png'),
      );
    });

    testWidgets('at max value', (tester) async {
      await tester.pumpGoldenWidget(
        NeoNumberSelector1(
          value: 100,
          max: 100,
          onChanged: (value) {},
        ),
        size: const Size(200, 80),
      );
      await expectLater(
        find.byType(NeoNumberSelector1),
        matchesGoldenFile('neo_number_selector_1_max.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        NeoNumberSelector1(
          value: 5,
          onChanged: (value) {},
        ),
        size: const Size(200, 80),
        isDark: true,
      );
      await expectLater(
        find.byType(NeoNumberSelector1),
        matchesGoldenFile('neo_number_selector_1_dark.png'),
      );
    });
  });
}
