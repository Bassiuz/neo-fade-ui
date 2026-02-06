import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_bottom_nav_cta_center_button.dart';
import 'neo_bottom_nav_cta_floating_button.dart';
import 'neo_bottom_nav_item.dart';

/// Bottom navigation with center CTA button.
///
/// When [floating] is false (default), the CTA button appears inline within the nav bar.
/// When [floating] is true, the CTA button floats above the nav bar with a spacer.
class NeoBottomNavCtaSimple extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<NeoBottomNavItem> items;
  final VoidCallback onCenterPressed;
  final IconData centerIcon;

  /// When true, the CTA button floats above the nav bar.
  /// When false (default), the CTA button appears inline within the nav bar.
  final bool floating;

  const NeoBottomNavCtaSimple({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.items,
    required this.onCenterPressed,
    this.centerIcon =
        const IconData(0xe145, fontFamily: 'MaterialIcons'), // add icon
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    if (floating) {
      return _buildFloatingStyle(context);
    }
    return _buildInlineStyle(context);
  }

  Widget _buildInlineStyle(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final leftItems = items.take((items.length / 2).floor()).toList();
    final rightItems = items.skip((items.length / 2).floor()).toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(NeoFadeRadii.xl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: NeoFadeSpacing.sm,
            vertical: NeoFadeSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: glass.tintOpacity + 0.1),
            borderRadius: BorderRadius.circular(NeoFadeRadii.xl),
            border: Border.all(
              color: colors.border.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Left items
              ...leftItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == selectedIndex;
                return _buildNavItem(item, isSelected, () => onIndexChanged(index), colors);
              }),

              // Center CTA button
              NeoBottomNavCtaCenterButton(
                icon: centerIcon,
                onPressed: onCenterPressed,
                colors: colors,
              ),

              // Right items
              ...rightItems.asMap().entries.map((entry) {
                final index = entry.key + leftItems.length;
                final item = entry.value;
                final isSelected = index == selectedIndex;
                return _buildNavItem(item, isSelected, () => onIndexChanged(index), colors);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingStyle(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final leftItems = items.take((items.length / 2).floor()).toList();
    final rightItems = items.skip((items.length / 2).floor()).toList();

    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        // Nav bar
        ClipRRect(
          borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: NeoFadeSpacing.md,
                vertical: NeoFadeSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: glass.tintOpacity + 0.1),
                borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
                border: Border.all(
                  color: colors.border.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Left items
                  ...leftItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = index == selectedIndex;
                    return Expanded(
                      child: _buildFloatingNavItem(
                          item, isSelected, () => onIndexChanged(index), colors),
                    );
                  }),

                  // Spacer for center button
                  const SizedBox(width: 70),

                  // Right items
                  ...rightItems.asMap().entries.map((entry) {
                    final index = entry.key + leftItems.length;
                    final item = entry.value;
                    final isSelected = index == selectedIndex;
                    return Expanded(
                      child: _buildFloatingNavItem(
                          item, isSelected, () => onIndexChanged(index), colors),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),

        // Floating center button
        Positioned(
          top: -25,
          child: NeoBottomNavCtaFloatingButton(
            icon: centerIcon,
            onPressed: onCenterPressed,
            colors: colors,
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
    NeoBottomNavItem item,
    bool isSelected,
    VoidCallback onTap,
    dynamic colors,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: NeoFadeSpacing.md,
          vertical: NeoFadeSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 24,
              color: isSelected ? colors.primary : colors.onSurfaceVariant,
            ),
            if (item.label != null) ...[
              const SizedBox(height: NeoFadeSpacing.xxs),
              Text(
                item.label!,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingNavItem(
    NeoBottomNavItem item,
    bool isSelected,
    VoidCallback onTap,
    dynamic colors,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: 24,
            color: isSelected ? colors.primary : colors.onSurfaceVariant,
          ),
          if (item.label != null) ...[
            const SizedBox(height: NeoFadeSpacing.xxs),
            Text(
              item.label!,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? colors.primary : colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
