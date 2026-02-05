import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_segmented_control_1.dart';

/// Glass segmented control with icons displayed above labels and a sliding gradient indicator.
class NeoSegmentedControlIcons<T> extends StatelessWidget {
  final T selectedValue;
  final ValueChanged<T> onValueChanged;
  final List<NeoSegment<T>> segments;

  const NeoSegmentedControlIcons({
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

    final selectedIndex = segments.indexWhere((s) => s.value == selectedValue);

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final segmentWidth = constraints.maxWidth / segments.length;
              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: NeoFadeAnimations.normal,
                    curve: NeoFadeAnimations.defaultCurve,
                    left: selectedIndex * segmentWidth,
                    top: 0,
                    bottom: 0,
                    width: segmentWidth,
                    child: Container(
                      margin: const EdgeInsets.all(NeoFadeSpacing.xxs),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colors.primary.withValues(alpha: 0.8),
                            colors.secondary.withValues(alpha: 0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(NeoFadeRadii.sm),
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.3),
                            blurRadius: NeoFadeSpacing.sm,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: segments.map((segment) {
                      final isSelected = segment.value == selectedValue;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => onValueChanged(segment.value),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: NeoFadeSpacing.sm,
                              horizontal: NeoFadeSpacing.xs,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (segment.icon != null)
                                  Icon(
                                    segment.icon,
                                    size: 22,
                                    color: isSelected
                                        ? colors.onPrimary
                                        : colors.onSurfaceVariant,
                                  ),
                                if (segment.icon != null)
                                  const SizedBox(height: NeoFadeSpacing.xxs),
                                Text(
                                  segment.label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight:
                                        isSelected ? FontWeight.w600 : FontWeight.normal,
                                    color: isSelected
                                        ? colors.onPrimary
                                        : colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
