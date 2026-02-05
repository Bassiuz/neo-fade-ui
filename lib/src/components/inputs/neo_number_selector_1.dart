import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_number_step_button.dart';

/// Glass number selector with +/- buttons and gradient accents.
class NeoNumberSelector1 extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;

  const NeoNumberSelector1({
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
      borderRadius: BorderRadius.circular(NeoFadeRadii.md),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
        child: Container(
          padding: const EdgeInsets.all(NeoFadeSpacing.xs),
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
            children: [
              NeoNumberStepButton(
                icon: Icons.remove,
                enabled: canDecrement,
                onPressed: () => onChanged(value - step),
                colors: colors,
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 60),
                padding:
                    const EdgeInsets.symmetric(horizontal: NeoFadeSpacing.md),
                child: Text(
                  value.toString(),
                  style: typography.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              NeoNumberStepButton(
                icon: Icons.add,
                enabled: canIncrement,
                onPressed: () => onChanged(value + step),
                colors: colors,
                isPrimary: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
