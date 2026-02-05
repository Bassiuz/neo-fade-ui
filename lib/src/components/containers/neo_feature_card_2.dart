import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';

/// Horizontal feature card with icon on left and gradient accent line.
class NeoFeatureCard2 extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const NeoFeatureCard2({
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
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: glass.tintOpacity),
              borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
              border: Border.all(
                color: colors.border.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [colors.primary, colors.secondary, colors.tertiary],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(NeoFadeRadii.lg),
                        bottomLeft: Radius.circular(NeoFadeRadii.lg),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(NeoFadeSpacing.md),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(NeoFadeSpacing.sm),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(NeoFadeRadii.md),
                            ),
                            child: Icon(
                              icon,
                              size: 24,
                              color: colors.primary,
                            ),
                          ),
                          const SizedBox(width: NeoFadeSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  style: typography.titleSmall,
                                ),
                                if (subtitle != null) ...[
                                  const SizedBox(height: NeoFadeSpacing.xxs),
                                  Text(
                                    subtitle!,
                                    style: typography.bodySmall.copyWith(
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Icon(
                            const IconData(0xe5df, fontFamily: 'MaterialIcons'),
                            size: 20,
                            color: colors.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
