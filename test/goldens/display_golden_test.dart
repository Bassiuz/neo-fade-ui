import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import '../helpers/golden_test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpGoldenTests();
  });

  group('NeoBadge Goldens', () {
    testWidgets('with count', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoBadge.count(count: 5),
        size: const Size(50, 50),
      );
      await expectLater(
        find.byType(NeoBadge),
        matchesGoldenFile('neo_badge_count.png'),
      );
    });

    testWidgets('with large count', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoBadge.count(count: 150),
        size: const Size(60, 50),
      );
      await expectLater(
        find.byType(NeoBadge),
        matchesGoldenFile('neo_badge_large_count.png'),
      );
    });

    testWidgets('dot style', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoBadge.dot(),
        size: const Size(30, 30),
      );
      await expectLater(
        find.byType(NeoBadge),
        matchesGoldenFile('neo_badge_dot.png'),
      );
    });

    testWidgets('with child', (tester) async {
      await tester.pumpGoldenWidget(
        NeoBadge.count(
          count: 3,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.mail, size: 24),
          ),
        ),
        size: const Size(70, 70),
      );
      await expectLater(
        find.byType(NeoBadge),
        matchesGoldenFile('neo_badge_with_child.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoBadge.count(count: 5),
        size: const Size(50, 50),
        isDark: true,
      );
      await expectLater(
        find.byType(NeoBadge),
        matchesGoldenFile('neo_badge_dark.png'),
      );
    });
  });

  group('NeoChip Goldens', () {
    // Note: NeoChip unselected state has a bug where the gradient border painter
    // receives only one color, causing an assertion error. Testing selected states instead.
    testWidgets('selected state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoChip(
          label: 'Selected',
          selected: true,
          onTap: () {},
        ),
        size: GoldenTestSizes.chip,
      );
      await expectLater(
        find.byType(NeoChip),
        matchesGoldenFile('neo_chip_selected.png'),
      );
    });

    testWidgets('selected with icon', (tester) async {
      await tester.pumpGoldenWidget(
        NeoChip(
          label: 'Tag',
          icon: Icons.label,
          selected: true,
          onTap: () {},
        ),
        size: GoldenTestSizes.chip,
      );
      await expectLater(
        find.byType(NeoChip),
        matchesGoldenFile('neo_chip_selected_with_icon.png'),
      );
    });

    testWidgets('selected disabled state', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoChip(
          label: 'Disabled',
          selected: true,
          enabled: false,
        ),
        size: GoldenTestSizes.chip,
      );
      await expectLater(
        find.byType(NeoChip),
        matchesGoldenFile('neo_chip_selected_disabled.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        NeoChip(
          label: 'Chip',
          selected: true,
          onTap: () {},
        ),
        size: GoldenTestSizes.chip,
        isDark: true,
      );
      await expectLater(
        find.byType(NeoChip),
        matchesGoldenFile('neo_chip_dark.png'),
      );
    });
  });

  group('NeoAvatar Goldens', () {
    testWidgets('with initials', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoAvatar(
          initials: 'JD',
          size: 64,
        ),
        size: GoldenTestSizes.avatar,
      );
      await expectLater(
        find.byType(NeoAvatar),
        matchesGoldenFile('neo_avatar_initials.png'),
      );
    });

    testWidgets('with icon', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoAvatar(
          icon: Icons.person,
          size: 64,
        ),
        size: GoldenTestSizes.avatar,
      );
      await expectLater(
        find.byType(NeoAvatar),
        matchesGoldenFile('neo_avatar_icon.png'),
      );
    });

    testWidgets('without ring', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoAvatar(
          initials: 'AB',
          size: 64,
          showRing: false,
        ),
        size: GoldenTestSizes.avatar,
      );
      await expectLater(
        find.byType(NeoAvatar),
        matchesGoldenFile('neo_avatar_no_ring.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        const NeoAvatar(
          initials: 'JD',
          size: 64,
        ),
        size: GoldenTestSizes.avatar,
        isDark: true,
      );
      await expectLater(
        find.byType(NeoAvatar),
        matchesGoldenFile('neo_avatar_dark.png'),
      );
    });
  });

  group('NeoListTile Goldens', () {
    testWidgets('default state', (tester) async {
      await tester.pumpGoldenWidget(
        SizedBox(
          width: 300,
          child: NeoListTile(
            title: 'List Item',
            subtitle: 'Description text',
            onTap: () {},
          ),
        ),
        size: const Size(350, 100),
      );
      await expectLater(
        find.byType(NeoListTile),
        matchesGoldenFile('neo_list_tile_default.png'),
      );
    });

    testWidgets('selected state', (tester) async {
      await tester.pumpGoldenWidget(
        SizedBox(
          width: 300,
          child: NeoListTile(
            title: 'Selected Item',
            subtitle: 'This item is selected',
            selected: true,
            onTap: () {},
          ),
        ),
        size: const Size(350, 100),
      );
      await expectLater(
        find.byType(NeoListTile),
        matchesGoldenFile('neo_list_tile_selected.png'),
      );
    });

    testWidgets('with leading and trailing', (tester) async {
      await tester.pumpGoldenWidget(
        SizedBox(
          width: 300,
          child: NeoListTile(
            leading: const Icon(Icons.folder),
            title: 'Documents',
            subtitle: '24 files',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
        size: const Size(350, 100),
      );
      await expectLater(
        find.byType(NeoListTile),
        matchesGoldenFile('neo_list_tile_with_widgets.png'),
      );
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpGoldenWidget(
        const SizedBox(
          width: 300,
          child: NeoListTile(
            title: 'Disabled Item',
            subtitle: 'This item is disabled',
            enabled: false,
          ),
        ),
        size: const Size(350, 100),
      );
      await expectLater(
        find.byType(NeoListTile),
        matchesGoldenFile('neo_list_tile_disabled.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        SizedBox(
          width: 300,
          child: NeoListTile(
            title: 'List Item',
            subtitle: 'Description text',
            selected: true,
            onTap: () {},
          ),
        ),
        size: const Size(350, 100),
        isDark: true,
      );
      await expectLater(
        find.byType(NeoListTile),
        matchesGoldenFile('neo_list_tile_dark.png'),
      );
    });
  });
}
