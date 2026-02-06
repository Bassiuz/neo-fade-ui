import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_bottom_nav_item.dart';

/// Glass bottom navigation bar with sliding gradient pill indicator.
///
/// When [floating] is false (default), displays a regular pill indicator that slides
/// behind the selected item.
/// When [floating] is true, displays a floating style with gradient glow on selected item.
class NeoBottomNavPill extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<NeoBottomNavItem> items;

  /// When true, displays a floating style with circular gradient glow.
  /// When false (default), displays a regular sliding pill indicator.
  final bool floating;

  const NeoBottomNavPill({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.items,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    if (floating) {
      return _buildFloatingStyle(context);
    }
    return _buildRegularStyle(context);
  }

  Widget _buildRegularStyle(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    return ClipRRect(
      borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
        child: Container(
          padding: const EdgeInsets.all(NeoFadeSpacing.xs),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: glass.tintOpacity),
            borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
            border: Border.all(
              color: colors.border.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / items.length;
              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: NeoFadeAnimations.normal,
                    curve: NeoFadeAnimations.defaultCurve,
                    left: selectedIndex * itemWidth + NeoFadeSpacing.xxs,
                    top: NeoFadeSpacing.xxs,
                    bottom: NeoFadeSpacing.xxs,
                    width: itemWidth - NeoFadeSpacing.xs,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colors.primary.withValues(alpha: 0.3),
                            colors.secondary.withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(NeoFadeRadii.md),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(items.length, (index) {
                      final isSelected = index == selectedIndex;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => onIndexChanged(index),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
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
                                if (items[index].label != null) ...[
                                  const SizedBox(height: NeoFadeSpacing.xxs),
                                  Text(
                                    items[index].label!,
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
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingStyle(BuildContext context) {
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
