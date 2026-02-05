import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import '../helpers/golden_test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpGoldenTests();
  });

  // Navigation bar needs a larger width to fit all items
  const navSize = Size(500, 120);

  group('NeoBottomNavCTA Goldens', () {
    testWidgets('first item selected', (tester) async {
      await tester.pumpGoldenWidget(
        NeoBottomNavCTA(
          selectedIndex: 0,
          onIndexChanged: (index) {},
          items: const [
            NeoBottomNavItem(icon: Icons.home, label: 'Home'),
            NeoBottomNavItem(icon: Icons.search, label: 'Search'),
            NeoBottomNavItem(icon: Icons.person, label: 'Profile'),
            NeoBottomNavItem(icon: Icons.settings, label: 'Settings'),
          ],
          onCenterPressed: () {},
          centerIcon: Icons.add,
          animated: false,
        ),
        size: navSize,
      );
      await expectLater(
        find.byType(NeoBottomNavCTA),
        matchesGoldenFile('neo_bottom_nav_cta_first.png'),
      );
    });

    testWidgets('last item selected', (tester) async {
      await tester.pumpGoldenWidget(
        NeoBottomNavCTA(
          selectedIndex: 3,
          onIndexChanged: (index) {},
          items: const [
            NeoBottomNavItem(icon: Icons.home, label: 'Home'),
            NeoBottomNavItem(icon: Icons.search, label: 'Search'),
            NeoBottomNavItem(icon: Icons.person, label: 'Profile'),
            NeoBottomNavItem(icon: Icons.settings, label: 'Settings'),
          ],
          onCenterPressed: () {},
          centerIcon: Icons.add,
          animated: false,
        ),
        size: navSize,
      );
      await expectLater(
        find.byType(NeoBottomNavCTA),
        matchesGoldenFile('neo_bottom_nav_cta_last.png'),
      );
    });

    testWidgets('with camera icon', (tester) async {
      await tester.pumpGoldenWidget(
        NeoBottomNavCTA(
          selectedIndex: 1,
          onIndexChanged: (index) {},
          items: const [
            NeoBottomNavItem(icon: Icons.home, label: 'Home'),
            NeoBottomNavItem(icon: Icons.favorite, label: 'Likes'),
            NeoBottomNavItem(icon: Icons.notifications, label: 'Alerts'),
            NeoBottomNavItem(icon: Icons.person, label: 'Profile'),
          ],
          onCenterPressed: () {},
          centerIcon: Icons.camera_alt,
          animated: false,
        ),
        size: navSize,
      );
      await expectLater(
        find.byType(NeoBottomNavCTA),
        matchesGoldenFile('neo_bottom_nav_cta_camera.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        NeoBottomNavCTA(
          selectedIndex: 0,
          onIndexChanged: (index) {},
          items: const [
            NeoBottomNavItem(icon: Icons.home, label: 'Home'),
            NeoBottomNavItem(icon: Icons.search, label: 'Search'),
            NeoBottomNavItem(icon: Icons.person, label: 'Profile'),
            NeoBottomNavItem(icon: Icons.settings, label: 'Settings'),
          ],
          onCenterPressed: () {},
          centerIcon: Icons.add,
          animated: false,
        ),
        size: navSize,
        isDark: true,
      );
      await expectLater(
        find.byType(NeoBottomNavCTA),
        matchesGoldenFile('neo_bottom_nav_cta_dark.png'),
      );
    });
  });
}
