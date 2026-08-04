import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import 'helpers/golden_test_helpers.dart';

/// These components used to build their icons by hand, as
/// `const IconData(0xe8b6, fontFamily: 'MaterialIcons')`. Those codepoints came
/// from an older MaterialIcons font — `Icons.search` is `0xe567` — so they
/// rendered as missing-glyph boxes on every current Flutter version.
///
/// None of them were golden-covered, which is why it went unnoticed. Comparing
/// against the `Icons` constants catches a regression without depending on how
/// a glyph rasterises.
void main() {
  setUpAll(() async {
    await setUpGoldenTests();
  });

  Future<void> pump(WidgetTester tester, Widget child) async {
    await tester.pumpGoldenWidget(child, size: const Size(400, 200));
  }

  IconData iconAt(WidgetTester tester, Finder finder) =>
      tester.widget<Icon>(finder).icon!;

  testWidgets('NeoSearchBar uses Icons.search', (tester) async {
    await pump(tester, const NeoSearchBar(hint: 'Search'));
    expect(iconAt(tester, find.byType(Icon).first), Icons.search);
  });

  testWidgets('NeoSearchBar clear button uses Icons.close', (tester) async {
    final controller = TextEditingController(text: 'typed');
    addTearDown(controller.dispose);
    await pump(tester, NeoSearchBar(controller: controller));
    expect(
      tester.widgetList<Icon>(find.byType(Icon)).map((i) => i.icon),
      contains(Icons.close),
    );
  });

  testWidgets('NeoAvatar falls back to Icons.person', (tester) async {
    await pump(tester, const NeoAvatar());
    expect(iconAt(tester, find.byType(Icon).first), Icons.person);
  });

  testWidgets('NeoBottomNavCTA defaults its centre to Icons.camera_alt', (
    tester,
  ) async {
    // Its own size, not the shared one — the bar needs the full bar height.
    await tester.pumpGoldenWidget(
      NeoBottomNavCTA(
        selectedIndex: 0,
        onIndexChanged: (_) {},
        onCenterPressed: () {},
        // The centre button pulses forever, and the helper pumpAndSettles.
        animated: false,
        items: const [
          NeoBottomNavItem(icon: Icons.home, label: 'Home'),
          NeoBottomNavItem(icon: Icons.settings, label: 'Settings'),
        ],
      ),
      size: const Size(390, 140),
    );
    expect(
      tester.widgetList<Icon>(find.byType(Icon)).map((i) => i.icon),
      contains(Icons.camera_alt),
    );
  });

  testWidgets('NeoChip delete button uses Icons.close', (tester) async {
    await pump(tester, NeoChip(label: 'Tag', onDelete: () {}));
    expect(
      tester.widgetList<Icon>(find.byType(Icon)).map((i) => i.icon),
      contains(Icons.close),
    );
  });

  testWidgets('number selectors use Icons.add and Icons.remove', (
    tester,
  ) async {
    await pump(
      tester,
      NeoNumberSelectorCompact(value: 5, onChanged: (_) {}, min: 0, max: 10),
    );
    final icons = tester.widgetList<Icon>(find.byType(Icon)).map((i) => i.icon);
    expect(icons, contains(Icons.add));
    expect(icons, contains(Icons.remove));
  });
}
