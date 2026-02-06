import 'package:flutter/widgets.dart';

import 'neo_bottom_nav_cta_simple.dart';
import 'neo_bottom_nav_dot.dart';
import 'neo_bottom_nav_expanding.dart';
import 'neo_bottom_nav_item.dart';
import 'neo_bottom_nav_pill.dart';

/// A unified bottom navigation bar with multiple style variants.
///
/// Use the named constructors to create different navigation bar styles:
/// - [NeoBottomNav.dot] - Dot indicator style
/// - [NeoBottomNav.pill] - Sliding pill indicator (regular or floating)
/// - [NeoBottomNav.expanding] - Expanding label on selected item
/// - [NeoBottomNav.cta] - Center CTA button (inline or floating)
abstract class NeoBottomNav extends StatelessWidget {
  const NeoBottomNav({super.key});

  /// Creates a bottom navigation bar with a gradient dot indicator.
  ///
  /// The dot appears below the selected icon.
  static NeoBottomNavDot dot({
    Key? key,
    required int selectedIndex,
    required ValueChanged<int> onIndexChanged,
    required List<NeoBottomNavItem> items,
  }) {
    return NeoBottomNavDot(
      key: key,
      selectedIndex: selectedIndex,
      onIndexChanged: onIndexChanged,
      items: items,
    );
  }

  /// Creates a bottom navigation bar with a sliding pill indicator.
  ///
  /// When [floating] is false (default), displays a regular pill indicator that
  /// slides behind the selected item.
  /// When [floating] is true, displays a floating style with circular gradient
  /// glow on the selected item.
  static NeoBottomNavPill pill({
    Key? key,
    required int selectedIndex,
    required ValueChanged<int> onIndexChanged,
    required List<NeoBottomNavItem> items,
    bool floating = false,
  }) {
    return NeoBottomNavPill(
      key: key,
      selectedIndex: selectedIndex,
      onIndexChanged: onIndexChanged,
      items: items,
      floating: floating,
    );
  }

  /// Creates a bottom navigation bar with expanding labels.
  ///
  /// The selected item expands to show its label.
  static NeoBottomNavExpanding expanding({
    Key? key,
    required int selectedIndex,
    required ValueChanged<int> onIndexChanged,
    required List<NeoBottomNavItem> items,
  }) {
    return NeoBottomNavExpanding(
      key: key,
      selectedIndex: selectedIndex,
      onIndexChanged: onIndexChanged,
      items: items,
    );
  }

  /// Creates a bottom navigation bar with a center CTA button.
  ///
  /// When [floating] is false (default), the CTA button appears inline within
  /// the nav bar.
  /// When [floating] is true, the CTA button floats above the nav bar with a
  /// spacer in its place.
  static NeoBottomNavCtaSimple cta({
    Key? key,
    required int selectedIndex,
    required ValueChanged<int> onIndexChanged,
    required List<NeoBottomNavItem> items,
    required VoidCallback onCenterPressed,
    IconData centerIcon =
        const IconData(0xe145, fontFamily: 'MaterialIcons'), // add icon
    bool floating = false,
  }) {
    return NeoBottomNavCtaSimple(
      key: key,
      selectedIndex: selectedIndex,
      onIndexChanged: onIndexChanged,
      items: items,
      onCenterPressed: onCenterPressed,
      centerIcon: centerIcon,
      floating: floating,
    );
  }
}
