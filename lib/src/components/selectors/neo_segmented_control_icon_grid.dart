import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_segment.dart';

/// Icon-only segmented control with gradient background on selected.
class NeoSegmentedControlIconGrid<T> extends StatelessWidget {
  final T selectedValue;
  final ValueChanged<T> onValueChanged;
  final List<NeoSegment<T>> segments;

  const NeoSegmentedControlIconGrid({
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
      borderRadius: BorderRadius.circular(NeoFadeRadii.md),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
        child: Container(
          padding: const EdgeInsets.all(NeoFadeSpacing.xxs),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: glass.tintOpacity),
            borderRadius: BorderRadius.circular(NeoFadeRadii.md),
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
                  margin: const EdgeInsets.all(NeoFadeSpacing.xxs),
                  padding: const EdgeInsets.all(NeoFadeSpacing.sm),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [colors.primary, colors.secondary],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(NeoFadeRadii.sm),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colors.primary.withValues(alpha: 0.4),
                              blurRadius: NeoFadeSpacing.sm,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                  ),
                  child: segment.icon != null
                      ? Icon(
                          segment.icon,
                          size: 20,
                          color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
                        )
                      : const SizedBox(width: 20, height: 20),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
