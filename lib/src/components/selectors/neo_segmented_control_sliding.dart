import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_segment.dart';

/// Glass segmented control with sliding gradient indicator.
class NeoSegmentedControlSliding<T> extends StatelessWidget {
  final T selectedValue;
  final ValueChanged<T> onValueChanged;
  final List<NeoSegment<T>> segments;

  /// Optional border radius for the container. Defaults to NeoFadeRadii.md.
  final double? borderRadius;

  /// Optional padding inside the container. Defaults to NeoFadeSpacing.xxs.
  final double? padding;

  /// Optional indicator padding. Defaults to NeoFadeSpacing.xxs.
  final double? indicatorPadding;

  /// Optional indicator border radius. Defaults to NeoFadeRadii.sm.
  final double? indicatorBorderRadius;

  /// Optional text style for segments. Color will be applied based on selection state.
  final TextStyle? textStyle;

  const NeoSegmentedControlSliding({
    super.key,
    required this.selectedValue,
    required this.onValueChanged,
    required this.segments,
    this.borderRadius,
    this.padding,
    this.indicatorPadding,
    this.indicatorBorderRadius,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final selectedIndex = segments.indexWhere((s) => s.value == selectedValue);

    final effectiveBorderRadius = borderRadius ?? NeoFadeRadii.md;
    final effectivePadding = padding ?? NeoFadeSpacing.xxs;
    final effectiveIndicatorPadding = indicatorPadding ?? NeoFadeSpacing.xxs;
    final effectiveIndicatorBorderRadius = indicatorBorderRadius ?? NeoFadeRadii.sm;
    final baseTextStyle = textStyle ?? const TextStyle(fontSize: 14);

    return ClipRRect(
      borderRadius: BorderRadius.circular(effectiveBorderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
        child: Container(
          padding: EdgeInsets.all(effectivePadding),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: glass.tintOpacity),
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
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
                      margin: EdgeInsets.all(effectiveIndicatorPadding),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colors.primary.withValues(alpha: 0.8),
                            colors.secondary.withValues(alpha: 0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(effectiveIndicatorBorderRadius),
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
                            child: Center(
                              child: Text(
                                segment.label,
                                style: baseTextStyle.copyWith(
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  color: isSelected ? colors.onPrimary : colors.onSurface,
                                ),
                              ),
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
