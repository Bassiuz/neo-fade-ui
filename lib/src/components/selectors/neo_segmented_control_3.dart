import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_segmented_control_1.dart';

/// Underline-style segmented control with gradient underline.
class NeoSegmentedControl3<T> extends StatelessWidget {
  final T selectedValue;
  final ValueChanged<T> onValueChanged;
  final List<NeoSegment<T>> segments;

  const NeoSegmentedControl3({
    super.key,
    required this.selectedValue,
    required this.onValueChanged,
    required this.segments,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;

    final selectedIndex = segments.indexWhere((s) => s.value == selectedValue);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: NeoFadeAnimations.fast,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? colors.primary : colors.onSurfaceVariant,
                      ),
                      child: Text(segment.label),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final segmentWidth = constraints.maxWidth / segments.length;
            return Stack(
              children: [
                Container(
                  height: 2,
                  color: colors.border.withValues(alpha: 0.3),
                ),
                AnimatedPositioned(
                  duration: NeoFadeAnimations.normal,
                  curve: NeoFadeAnimations.defaultCurve,
                  left: selectedIndex * segmentWidth,
                  top: 0,
                  width: segmentWidth,
                  height: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colors.primary, colors.secondary, colors.tertiary],
                      ),
                      borderRadius: BorderRadius.circular(1),
                      boxShadow: [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.5),
                          blurRadius: NeoFadeSpacing.xs,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
