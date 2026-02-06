import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import '../helpers/golden_test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpGoldenTests();
  });

  group('NeoSegmentedControlSliding Goldens', () {
    testWidgets('first selected', (tester) async {
      await tester.pumpGoldenWidget(
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320, maxHeight: 60),
          child: NeoSegmentedControl.sliding<int>(
            selectedValue: 0,
            onValueChanged: (value) {},
            segments: const [
              NeoSegment(value: 0, label: 'Daily'),
              NeoSegment(value: 1, label: 'Weekly'),
              NeoSegment(value: 2, label: 'Monthly'),
            ],
          ),
        ),
        size: GoldenTestSizes.selector,
      );
      await expectLater(
        find.byType(NeoSegmentedControlSliding<int>),
        matchesGoldenFile('neo_segmented_control_sliding_first.png'),
      );
    });

    testWidgets('middle selected', (tester) async {
      await tester.pumpGoldenWidget(
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320, maxHeight: 60),
          child: NeoSegmentedControl.sliding<int>(
            selectedValue: 1,
            onValueChanged: (value) {},
            segments: const [
              NeoSegment(value: 0, label: 'Daily'),
              NeoSegment(value: 1, label: 'Weekly'),
              NeoSegment(value: 2, label: 'Monthly'),
            ],
          ),
        ),
        size: GoldenTestSizes.selector,
      );
      await expectLater(
        find.byType(NeoSegmentedControlSliding<int>),
        matchesGoldenFile('neo_segmented_control_sliding_middle.png'),
      );
    });

    testWidgets('last selected', (tester) async {
      await tester.pumpGoldenWidget(
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320, maxHeight: 60),
          child: NeoSegmentedControl.sliding<int>(
            selectedValue: 2,
            onValueChanged: (value) {},
            segments: const [
              NeoSegment(value: 0, label: 'Daily'),
              NeoSegment(value: 1, label: 'Weekly'),
              NeoSegment(value: 2, label: 'Monthly'),
            ],
          ),
        ),
        size: GoldenTestSizes.selector,
      );
      await expectLater(
        find.byType(NeoSegmentedControlSliding<int>),
        matchesGoldenFile('neo_segmented_control_sliding_last.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320, maxHeight: 60),
          child: NeoSegmentedControl.sliding<int>(
            selectedValue: 1,
            onValueChanged: (value) {},
            segments: const [
              NeoSegment(value: 0, label: 'Daily'),
              NeoSegment(value: 1, label: 'Weekly'),
              NeoSegment(value: 2, label: 'Monthly'),
            ],
          ),
        ),
        size: GoldenTestSizes.selector,
        isDark: true,
      );
      await expectLater(
        find.byType(NeoSegmentedControlSliding<int>),
        matchesGoldenFile('neo_segmented_control_sliding_dark.png'),
      );
    });
  });

  group('NeoSegmentedControlIcons Goldens', () {
    testWidgets('first selected', (tester) async {
      await tester.pumpGoldenWidget(
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320, maxHeight: 80),
          child: NeoSegmentedControlIcons<int>(
            selectedValue: 0,
            onValueChanged: (value) {},
            segments: const [
              NeoSegment(value: 0, label: 'Home', icon: Icons.home),
              NeoSegment(value: 1, label: 'Search', icon: Icons.search),
              NeoSegment(value: 2, label: 'Settings', icon: Icons.settings),
            ],
          ),
        ),
        size: const Size(350, 100),
      );
      await expectLater(
        find.byType(NeoSegmentedControlIcons<int>),
        matchesGoldenFile('neo_segmented_control_icons_first.png'),
      );
    });

    testWidgets('middle selected', (tester) async {
      await tester.pumpGoldenWidget(
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320, maxHeight: 80),
          child: NeoSegmentedControlIcons<int>(
            selectedValue: 1,
            onValueChanged: (value) {},
            segments: const [
              NeoSegment(value: 0, label: 'Home', icon: Icons.home),
              NeoSegment(value: 1, label: 'Search', icon: Icons.search),
              NeoSegment(value: 2, label: 'Settings', icon: Icons.settings),
            ],
          ),
        ),
        size: const Size(350, 100),
      );
      await expectLater(
        find.byType(NeoSegmentedControlIcons<int>),
        matchesGoldenFile('neo_segmented_control_icons_middle.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320, maxHeight: 80),
          child: NeoSegmentedControlIcons<int>(
            selectedValue: 1,
            onValueChanged: (value) {},
            segments: const [
              NeoSegment(value: 0, label: 'Home', icon: Icons.home),
              NeoSegment(value: 1, label: 'Search', icon: Icons.search),
              NeoSegment(value: 2, label: 'Settings', icon: Icons.settings),
            ],
          ),
        ),
        size: const Size(350, 100),
        isDark: true,
      );
      await expectLater(
        find.byType(NeoSegmentedControlIcons<int>),
        matchesGoldenFile('neo_segmented_control_icons_dark.png'),
      );
    });
  });
}
