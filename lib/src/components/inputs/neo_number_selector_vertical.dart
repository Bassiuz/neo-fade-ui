import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_number_selector_arrow_button.dart';

/// Vertical number selector with gradient highlight.
class NeoNumberSelectorVertical extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;

  const NeoNumberSelectorVertical({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.step = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;
    final typography = theme.typography;

    final canDecrement = value > min;
    final canIncrement = value < max;

    return ClipRRect(
      borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
        child: Container(
          padding: const EdgeInsets.all(NeoFadeSpacing.sm),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: glass.tintOpacity),
            borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
            border: Border.all(
              color: colors.border.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NeoNumberSelectorArrowButton(
                icon: const IconData(0xe5ce,
                    fontFamily: 'MaterialIcons'), // arrow up
                enabled: canIncrement,
                onPressed: () => onChanged(value + step),
                colors: colors,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: NeoFadeSpacing.md,
                  horizontal: NeoFadeSpacing.lg,
                ),
                margin: const EdgeInsets.symmetric(vertical: NeoFadeSpacing.xs),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      colors.primary.withValues(alpha: 0.2),
                      colors.secondary.withValues(alpha: 0.15),
                      colors.tertiary.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(NeoFadeRadii.md),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  value.toString(),
                  style: typography.headlineMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              NeoNumberSelectorArrowButton(
                icon: const IconData(0xe5cf,
                    fontFamily: 'MaterialIcons'), // arrow down
                enabled: canDecrement,
                onPressed: () => onChanged(value - step),
                colors: colors,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
