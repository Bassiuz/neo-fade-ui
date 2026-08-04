import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import 'helpers/golden_test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpGoldenTests();
  });

  Future<void> pump(WidgetTester tester, Widget child) =>
      tester.pumpGoldenWidget(child, size: const Size(400, 200));

  testWidgets('renders its hint when empty', (tester) async {
    await pump(tester, const NeoSearchBar(hint: 'Search songs'));
    expect(find.text('Search songs'), findsOneWidget);
  });

  testWidgets('renders the text its controller was given', (tester) async {
    final controller = TextEditingController(text: 'radiohead');
    addTearDown(controller.dispose);
    await pump(tester, NeoSearchBar(controller: controller, hint: 'Search'));
    expect(find.text('radiohead'), findsOneWidget);
    // The hint stays in the tree — InputDecorator fades it out rather than
    // removing it — so this asserts on opacity, not on absence.
    expect(
      tester
          .widget<AnimatedOpacity>(
            find
                .ancestor(
                  of: find.text('Search'),
                  matching: find.byType(AnimatedOpacity),
                )
                .first,
          )
          .opacity,
      0,
    );
  });

  testWidgets('setting the controller text does not report as user input', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final seen = <String>[];
    await pump(
      tester,
      NeoSearchBar(controller: controller, onChanged: seen.add),
    );
    controller.text = 'set programmatically';
    await tester.pump();
    expect(seen, isEmpty);
  });

  testWidgets('is tall enough for a line of text', (tester) async {
    await pump(tester, const NeoSearchBar(hint: 'Search'));
    expect(
      tester.getSize(find.byType(NeoSearchBar)).height,
      greaterThanOrEqualTo(48),
    );
  });

  testWidgets('onChanged fires on typing', (tester) async {
    final seen = <String>[];
    await pump(tester, NeoSearchBar(onChanged: seen.add));
    await tester.enterText(find.byType(TextField), 'kid a');
    expect(seen, ['kid a']);
  });
}
