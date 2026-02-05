import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';

/// Subtle gradient divider line.
///
/// A divider with a subtle gradient effect, optionally with
/// label text in the middle.
class NeoDivider extends StatelessWidget {
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final String? label;
  final bool vertical;

  const NeoDivider({
    super.key,
    this.thickness,
    this.indent,
    this.endIndent,
    this.label,
    this.vertical = false,
  });

  const NeoDivider.vertical({
    super.key,
    this.thickness,
    this.indent,
    this.endIndent,
  })  : label = null,
        vertical = true;

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;

    final effectiveThickness = thickness ?? 1.0;

    final gradientColors = [
      colors.primary.withValues(alpha: 0.0),
      colors.primary.withValues(alpha: 0.3),
      colors.secondary.withValues(alpha: 0.3),
      colors.tertiary.withValues(alpha: 0.3),
      colors.tertiary.withValues(alpha: 0.0),
    ];

    if (vertical) {
      return Container(
        width: effectiveThickness,
        margin: EdgeInsets.only(
          top: indent ?? 0,
          bottom: endIndent ?? 0,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
      );
    }

    if (label != null) {
      return Row(
        children: [
          Expanded(
            child: Container(
              height: effectiveThickness,
              margin: EdgeInsets.only(
                left: indent ?? 0,
                right: NeoFadeSpacing.md,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors.primary.withValues(alpha: 0.0),
                    colors.primary.withValues(alpha: 0.3),
                    colors.secondary.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [colors.primary, colors.secondary, colors.tertiary],
            ).createShader(bounds),
            child: Text(
              label!,
              style: theme.typography.labelSmall.copyWith(
                color: colors.onPrimary,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: effectiveThickness,
              margin: EdgeInsets.only(
                left: NeoFadeSpacing.md,
                right: endIndent ?? 0,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors.secondary.withValues(alpha: 0.3),
                    colors.tertiary.withValues(alpha: 0.3),
                    colors.tertiary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      height: effectiveThickness,
      margin: EdgeInsets.only(
        left: indent ?? 0,
        right: endIndent ?? 0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
        ),
      ),
    );
  }
}
