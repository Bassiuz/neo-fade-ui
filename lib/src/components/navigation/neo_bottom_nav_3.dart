import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_bottom_nav_1.dart';

/// Floating bottom navigation bar with gradient glow on selected item.
class NeoBottomNav3 extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<NeoBottomNavItem> items;

  const NeoBottomNav3({
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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(NeoFadeRadii.full),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.2),
            blurRadius: NeoFadeSpacing.lg,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(NeoFadeRadii.full),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: NeoFadeSpacing.sm,
              vertical: NeoFadeSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: glass.tintOpacity + 0.1),
              borderRadius: BorderRadius.circular(NeoFadeRadii.full),
              border: Border.all(
                color: colors.border.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(items.length, (index) {
                final isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () => onIndexChanged(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: NeoFadeAnimations.normal,
                    curve: NeoFadeAnimations.defaultCurve,
                    margin: const EdgeInsets.symmetric(horizontal: NeoFadeSpacing.xxs),
                    padding: const EdgeInsets.all(NeoFadeSpacing.sm),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelected
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [colors.primary, colors.secondary],
                            )
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: colors.primary.withValues(alpha: 0.4),
                                blurRadius: NeoFadeSpacing.md,
                                spreadRadius: 0,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      items[index].icon,
                      size: 22,
                      color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
