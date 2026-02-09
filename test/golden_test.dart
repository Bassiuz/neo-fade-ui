import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import 'helpers/golden_test_helpers.dart';

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
        matchesGoldenFile('goldens/neo_button_1_default.png'),
      );
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoButtonFilled(label: 'Button', onPressed: null),
        size: GoldenTestSizes.button,
      );
      await expectLater(
        find.byType(NeoButtonFilled),
        matchesGoldenFile('goldens/neo_button_1_disabled.png'),
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
        matchesGoldenFile('goldens/neo_button_1_dark.png'),
      );
    });
  });
}
