import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_number_selector_circle_button.dart';

/// Pill-shaped compact number selector.
class NeoNumberSelectorCompact extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;

  const NeoNumberSelectorCompact({
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
      borderRadius: BorderRadius.circular(NeoFadeRadii.full),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
        child: Container(
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
            children: [
              NeoNumberSelectorCircleButton(
                icon: const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                enabled: canDecrement,
                onPressed: () => onChanged(value - step),
                colors: colors,
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 50),
                padding:
                    const EdgeInsets.symmetric(horizontal: NeoFadeSpacing.sm),
                child: Text(
                  value.toString(),
                  style: typography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              NeoNumberSelectorCircleButton(
                icon: const IconData(0xe145, fontFamily: 'MaterialIcons'),
                enabled: canIncrement,
                onPressed: () => onChanged(value + step),
                colors: colors,
                isGradient: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
