import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import '../helpers/golden_test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpGoldenTests();
  });

  group('NeoTextFieldOutlined Goldens', () {
    testWidgets('default state', (tester) async {
      await tester.pumpGoldenWidget(
        const SizedBox(
          width: 280,
          child: NeoTextFieldOutlined(
            hintText: 'Enter text...',
          ),
        ),
        size: GoldenTestSizes.input,
      );
      await expectLater(
        find.byType(NeoTextFieldOutlined),
        matchesGoldenFile('neo_text_field_outlined_default.png'),
      );
    });

    testWidgets('with label', (tester) async {
      await tester.pumpGoldenWidget(
        const SizedBox(
          width: 280,
          child: NeoTextFieldOutlined(
            labelText: 'Email',
            hintText: 'Enter email...',
          ),
        ),
        size: const Size(300, 100),
      );
      await expectLater(
        find.byType(NeoTextFieldOutlined),
        matchesGoldenFile('neo_text_field_outlined_with_label.png'),
      );
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpGoldenWidget(
        const SizedBox(
          width: 280,
          child: NeoTextFieldOutlined(
            hintText: 'Enter text...',
            enabled: false,
          ),
        ),
        size: GoldenTestSizes.input,
      );
      await expectLater(
        find.byType(NeoTextFieldOutlined),
        matchesGoldenFile('neo_text_field_outlined_disabled.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        const SizedBox(
          width: 280,
          child: NeoTextFieldOutlined(
            hintText: 'Enter text...',
          ),
        ),
        size: GoldenTestSizes.input,
        isDark: true,
      );
      await expectLater(
        find.byType(NeoTextFieldOutlined),
        matchesGoldenFile('neo_text_field_outlined_dark.png'),
      );
    });
  });

  group('NeoCheckboxGlowBorder Goldens', () {
    testWidgets('unchecked state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoCheckboxGlowBorder(
          value: false,
          onChanged: (value) {},
        ),
        size: const Size(60, 60),
      );
      await expectLater(
        find.byType(NeoCheckboxGlowBorder),
        matchesGoldenFile('neo_checkbox_4_unchecked.png'),
      );
    });

    testWidgets('checked state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoCheckboxGlowBorder(
          value: true,
          onChanged: (value) {},
        ),
        size: const Size(60, 60),
      );
      await expectLater(
        find.byType(NeoCheckboxGlowBorder),
        matchesGoldenFile('neo_checkbox_4_checked.png'),
      );
    });

    testWidgets('with label', (tester) async {
      await tester.pumpGoldenWidget(
        NeoCheckboxGlowBorder(
          value: true,
          label: 'Accept terms',
          onChanged: (value) {},
        ),
        size: const Size(220, 60),
      );
      await expectLater(
        find.byType(NeoCheckboxGlowBorder),
        matchesGoldenFile('neo_checkbox_4_with_label.png'),
      );
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoCheckboxGlowBorder(
          value: false,
          onChanged: null,
        ),
        size: const Size(60, 60),
      );
      await expectLater(
        find.byType(NeoCheckboxGlowBorder),
        matchesGoldenFile('neo_checkbox_4_disabled.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        NeoCheckboxGlowBorder(
          value: true,
          onChanged: (value) {},
        ),
        size: const Size(60, 60),
        isDark: true,
      );
      await expectLater(
        find.byType(NeoCheckboxGlowBorder),
        matchesGoldenFile('neo_checkbox_4_dark.png'),
      );
    });
  });

  group('NeoSwitchIos Goldens', () {
    testWidgets('off state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoSwitchIos(
          value: false,
          onChanged: (value) {},
        ),
        size: const Size(80, 60),
      );
      await expectLater(
        find.byType(NeoSwitchIos),
        matchesGoldenFile('neo_switch_ios_off.png'),
      );
    });

    testWidgets('on state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoSwitchIos(
          value: true,
          onChanged: (value) {},
        ),
        size: const Size(80, 60),
      );
      await expectLater(
        find.byType(NeoSwitchIos),
        matchesGoldenFile('neo_switch_ios_on.png'),
      );
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoSwitchIos(
          value: false,
          enabled: false,
        ),
        size: const Size(80, 60),
      );
      await expectLater(
        find.byType(NeoSwitchIos),
        matchesGoldenFile('neo_switch_ios_disabled.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        NeoSwitchIos(
          value: true,
          onChanged: (value) {},
        ),
        size: const Size(80, 60),
        isDark: true,
      );
      await expectLater(
        find.byType(NeoSwitchIos),
        matchesGoldenFile('neo_switch_ios_dark.png'),
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

  group('NeoNumberSelectorHorizontal Goldens', () {
    testWidgets('default state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoNumberSelector.horizontal(
          value: 5,
          onChanged: (value) {},
        ),
        size: const Size(200, 80),
      );
      await expectLater(
        find.byType(NeoNumberSelectorHorizontal),
        matchesGoldenFile('neo_number_selector_1_default.png'),
      );
    });

    testWidgets('at min value', (tester) async {
      await tester.pumpGoldenWidget(
        NeoNumberSelector.horizontal(
          value: 0,
          min: 0,
          onChanged: (value) {},
        ),
        size: const Size(200, 80),
      );
      await expectLater(
        find.byType(NeoNumberSelectorHorizontal),
        matchesGoldenFile('neo_number_selector_1_min.png'),
      );
    });

    testWidgets('at max value', (tester) async {
      await tester.pumpGoldenWidget(
        NeoNumberSelector.horizontal(
          value: 100,
          max: 100,
          onChanged: (value) {},
        ),
        size: const Size(200, 80),
      );
      await expectLater(
        find.byType(NeoNumberSelectorHorizontal),
        matchesGoldenFile('neo_number_selector_1_max.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        NeoNumberSelector.horizontal(
          value: 5,
          onChanged: (value) {},
        ),
        size: const Size(200, 80),
        isDark: true,
      );
      await expectLater(
        find.byType(NeoNumberSelectorHorizontal),
        matchesGoldenFile('neo_number_selector_1_dark.png'),
      );
    });
  });
}
