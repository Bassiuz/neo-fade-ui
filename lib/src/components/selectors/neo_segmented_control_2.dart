import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_segmented_control_1.dart';

/// Pill-shaped segmented control with gradient outline on selected.
class NeoSegmentedControl2<T> extends StatelessWidget {
  final T selectedValue;
  final ValueChanged<T> onValueChanged;
  final List<NeoSegment<T>> segments;

  const NeoSegmentedControl2({
    super.key,
    required this.selectedValue,
    required this.onValueChanged,
    required this.segments,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    return ClipRRect(
      borderRadius: BorderRadius.circular(NeoFadeRadii.full),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
        child: Container(
          padding: const EdgeInsets.all(NeoFadeSpacing.xxs),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: glass.tintOpacity),
            borderRadius: BorderRadius.circular(NeoFadeRadii.full),
            border: Border.all(
              color: colors.border.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: segments.map((segment) {
              final isSelected = segment.value == selectedValue;
              return GestureDetector(
                onTap: () => onValueChanged(segment.value),
                child: AnimatedContainer(
                  duration: NeoFadeAnimations.normal,
                  curve: NeoFadeAnimations.defaultCurve,
                  margin: const EdgeInsets.symmetric(horizontal: NeoFadeSpacing.xxs),
                  padding: const EdgeInsets.symmetric(
                    vertical: NeoFadeSpacing.xs,
                    horizontal: NeoFadeSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.surface.withValues(alpha: 0.8)
                        : null,
                    borderRadius: BorderRadius.circular(NeoFadeRadii.full),
                    border: isSelected
                        ? Border.all(
                            color: colors.primary,
                            width: 2,
                          )
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colors.primary.withValues(alpha: 0.3),
                              blurRadius: NeoFadeSpacing.sm,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (segment.icon != null) ...[
                        Icon(
                          segment.icon,
                          size: 18,
                          color: isSelected ? colors.primary : colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: NeoFadeSpacing.xs),
                      ],
                      Text(
                        segment.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? colors.primary : colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
