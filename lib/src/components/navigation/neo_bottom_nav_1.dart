import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Glass bottom navigation bar with gradient indicator dot.
class NeoBottomNav1 extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<NeoBottomNavItem> items;

  const NeoBottomNav1({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    return ClipRRect(
      borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: NeoFadeSpacing.md,
            vertical: NeoFadeSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: glass.tintOpacity),
            borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
            border: Border.all(
              color: colors.border.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = index == selectedIndex;
              return GestureDetector(
                onTap: () => onIndexChanged(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: NeoFadeAnimations.normal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: NeoFadeSpacing.md,
                    vertical: NeoFadeSpacing.sm,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[index].icon,
                        size: 24,
                        color: isSelected ? colors.primary : colors.onSurfaceVariant,
                      ),
                      const SizedBox(height: NeoFadeSpacing.xxs),
                      AnimatedContainer(
                        duration: NeoFadeAnimations.normal,
                        width: isSelected ? 6 : 0,
                        height: isSelected ? 6 : 0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [colors.primary, colors.secondary],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class NeoBottomNavItem {
  final IconData icon;
  final String? label;

  const NeoBottomNavItem({required this.icon, this.label});
}
