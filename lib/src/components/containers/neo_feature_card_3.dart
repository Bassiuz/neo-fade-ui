import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';

/// Feature card with large centered icon and gradient glow.
class NeoFeatureCard3 extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const NeoFeatureCard3({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;
    final typography = theme.typography;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
          child: Container(
            padding: const EdgeInsets.all(NeoFadeSpacing.lg),
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
                Container(
                  padding: const EdgeInsets.all(NeoFadeSpacing.lg),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surface.withValues(alpha: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.4),
                        blurRadius: NeoFadeSpacing.xl,
                        spreadRadius: NeoFadeSpacing.xs,
                      ),
                      BoxShadow(
                        color: colors.secondary.withValues(alpha: 0.3),
                        blurRadius: NeoFadeSpacing.xxl,
                        spreadRadius: NeoFadeSpacing.sm,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: NeoFadeSpacing.lg),
                Text(
                  title,
                  style: typography.titleMedium,
                  textAlign: TextAlign.center,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: NeoFadeSpacing.xs),
                  Text(
                    subtitle!,
                    style: typography.bodySmall.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
