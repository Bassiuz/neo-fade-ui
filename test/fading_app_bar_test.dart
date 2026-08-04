import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import 'helpers/golden_test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpGoldenTests();
  });

  testWidgets('renders its title, leading and actions', (tester) async {
    await tester.pumpGoldenWidget(
      NeoFadingAppBar(
        title: 'Library',
        leading: NeoIconButton(icon: Icons.arrow_back, onPressed: () {}),
        actions: [NeoIconButton(icon: Icons.sync, onPressed: () {})],
      ),
      size: const Size(390, 140),
    );
    expect(find.text('Library'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.sync), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a two-line title makes it taller, not overflowing', (
    tester,
  ) async {
    await tester.pumpGoldenWidget(
      const NeoFadingAppBar(title: 'Short'),
      size: const Size(390, 200),
    );
    final short = tester.getSize(find.byType(NeoFadingAppBar)).height;

    await tester.pumpGoldenWidget(
      const NeoFadingAppBar(
        title: 'A title long enough to need a second line to fit',
      ),
      size: const Size(390, 200),
    );
    expect(
      tester.getSize(find.byType(NeoFadingAppBar)).height,
      greaterThan(short),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('borderHeight: 0 drops the hairline', (tester) async {
    await tester.pumpGoldenWidget(
      const NeoFadingAppBar(title: 'Library', borderHeight: 0),
      size: const Size(390, 140),
    );
    final without = tester.getSize(find.byType(NeoFadingAppBar)).height;

    await tester.pumpGoldenWidget(
      const NeoFadingAppBar(title: 'Library'),
      size: const Size(390, 140),
    );
    expect(tester.getSize(find.byType(NeoFadingAppBar)).height, without + 2);
  });

  testWidgets('golden', (tester) async {
    await tester.pumpGoldenWidget(
      NeoFadingAppBar(
        title: 'Library',
        leading: NeoIconButton(icon: Icons.arrow_back, onPressed: () {}),
        actions: [NeoIconButton(icon: Icons.sync, onPressed: () {})],
      ),
      size: const Size(390, 100),
    );
    await expectLater(
      find.byType(NeoFadingAppBar),
      matchesGoldenFile('goldens/neo_fading_app_bar_1_default.png'),
    );
  });
}
