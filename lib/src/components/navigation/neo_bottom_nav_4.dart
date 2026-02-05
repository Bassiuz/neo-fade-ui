import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_bottom_nav_1.dart';

/// Bottom navigation with expanding label on selected item.
class NeoBottomNav4 extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<NeoBottomNavItem> items;

  const NeoBottomNav4({
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
            horizontal: NeoFadeSpacing.sm,
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
                  curve: NeoFadeAnimations.defaultCurve,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? NeoFadeSpacing.md : NeoFadeSpacing.sm,
                    vertical: NeoFadeSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.primary.withValues(alpha: 0.15)
                        : null,
                    borderRadius: BorderRadius.circular(NeoFadeRadii.full),
                    border: isSelected
                        ? Border.all(
                            color: colors.primary.withValues(alpha: 0.3),
                            width: 1,
                          )
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[index].icon,
                        size: 22,
                        color: isSelected ? colors.primary : colors.onSurfaceVariant,
                      ),
                      if (isSelected && items[index].label != null) ...[
                        const SizedBox(width: NeoFadeSpacing.xs),
                        Text(
                          items[index].label!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                          ),
                        ),
                      ],
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
