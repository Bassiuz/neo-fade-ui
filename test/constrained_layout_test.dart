import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import 'helpers/golden_test_helpers.dart';

/// Both of these bit Moxly: a component that lays out fine unconstrained but
/// overflows or grows the moment it is given a width or a fixed row height.
void main() {
  setUpAll(() async {
    await setUpGoldenTests();
  });

  group('buttons in a narrow slot', () {
    for (final entry in <String, Widget Function()>{
      'filled': () => NeoButtonFilled(
        label: 'A very long button label',
        icon: Icons.download,
        onPressed: () {},
      ),
      'gradientBorder': () => NeoButtonGradientBorder(
        label: 'A very long button label',
        icon: Icons.download,
        onPressed: () {},
      ),
      'pill': () => NeoButtonPill(
        label: 'A very long button label',
        icon: Icons.download,
        onPressed: () {},
      ),
      'soft': () => NeoButtonSoft(
        label: 'A very long button label',
        icon: Icons.download,
        onPressed: () {},
      ),
    }.entries) {
      testWidgets('${entry.key} ellipsises rather than overflowing', (
        tester,
      ) async {
        await tester.pumpGoldenWidget(
          SizedBox(width: 90, child: entry.value()),
          size: const Size(200, 100),
        );
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('NeoListTile with maxLines', () {
    testWidgets('a long title does not make the row taller', (tester) async {
      await tester.pumpGoldenWidget(
        const SizedBox(
          width: 280,
          child: NeoListTile(
            title:
                'A title long enough that it would otherwise wrap over lines',
            subtitle: 'And a subtitle that would also wrap given half a chance',
            titleMaxLines: 1,
            subtitleMaxLines: 1,
          ),
        ),
        size: const Size(300, 200),
      );
      final long = tester.getSize(find.byType(NeoListTile)).height;

      await tester.pumpGoldenWidget(
        const SizedBox(
          width: 280,
          child: NeoListTile(
            title: 'Short',
            subtitle: 'Short',
            titleMaxLines: 1,
            subtitleMaxLines: 1,
          ),
        ),
        size: const Size(300, 200),
      );
      expect(tester.getSize(find.byType(NeoListTile)).height, long);
    });

    testWidgets('without maxLines it still wraps, as before', (tester) async {
      await tester.pumpGoldenWidget(
        const SizedBox(
          width: 280,
          child: NeoListTile(
            title:
                'A title long enough that it would otherwise wrap over lines',
          ),
        ),
        size: const Size(300, 200),
      );
      final wrapped = tester.getSize(find.byType(NeoListTile)).height;

      await tester.pumpGoldenWidget(
        const SizedBox(width: 280, child: NeoListTile(title: 'Short')),
        size: const Size(300, 200),
      );
      expect(
        tester.getSize(find.byType(NeoListTile)).height,
        lessThan(wrapped),
      );
    });
  });
}
