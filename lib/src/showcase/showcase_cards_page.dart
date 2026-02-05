import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// Cards showcase page displaying NeoCard1 and NeoFeatureCard1 variants.
class ShowcaseCardsPage extends StatelessWidget {
  const ShowcaseCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(NeoFadeSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cards', style: theme.typography.headlineMedium),
          const SizedBox(height: NeoFadeSpacing.lg),

          // NeoCard1 Section
          Text('NeoCard1 - Gradient Top Border', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'A card with a gradient accent along the top edge.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          NeoCard1(
            padding: const EdgeInsets.all(NeoFadeSpacing.lg),
            child: Text(
              'This card has a gradient top border accent that adds visual interest.',
              style: theme.typography.bodyMedium,
            ),
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          NeoCard1(
            padding: const EdgeInsets.all(NeoFadeSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Card Title', style: theme.typography.titleSmall),
                const SizedBox(height: NeoFadeSpacing.sm),
                Text(
                  'Cards can contain multiple elements with proper spacing and layout.',
                  style: theme.typography.bodyMedium,
                ),
                const SizedBox(height: NeoFadeSpacing.md),
                Row(
                  children: [
                    Icon(Icons.star, color: theme.colors.primary, size: 20),
                    const SizedBox(width: NeoFadeSpacing.xs),
                    Text('Featured content', style: theme.typography.labelMedium),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // NeoFeatureCard1 Section
          Text('NeoFeatureCard1 - Gradient Icon Box', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'Feature cards with a gradient icon container.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          Row(
            children: [
              Expanded(
                child: NeoFeatureCard1(
                  icon: Icons.flash_on,
                  title: 'Fast Performance',
                  subtitle: 'Optimized for speed',
                ),
              ),
              const SizedBox(width: NeoFadeSpacing.md),
              Expanded(
                child: NeoFeatureCard1(
                  icon: Icons.security,
                  title: 'Secure',
                  subtitle: 'Enterprise-grade',
                ),
              ),
            ],
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          Row(
            children: [
              Expanded(
                child: NeoFeatureCard1(
                  icon: Icons.cloud_done,
                  title: 'Cloud Sync',
                  subtitle: 'Always up to date',
                ),
              ),
              const SizedBox(width: NeoFadeSpacing.md),
              Expanded(
                child: NeoFeatureCard1(
                  icon: Icons.palette,
                  title: 'Customizable',
                  subtitle: 'Theming support',
                ),
              ),
            ],
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // Combined Layout Example
          Text('Card Layout Example', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'Example of using cards together in a layout.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          NeoCard1(
            padding: const EdgeInsets.all(NeoFadeSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Choose a Feature', style: theme.typography.titleSmall),
                const SizedBox(height: NeoFadeSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: NeoFeatureCard1(
                        icon: Icons.auto_awesome,
                        title: 'AI Powered',
                        subtitle: 'Smart automation',
                      ),
                    ),
                    const SizedBox(width: NeoFadeSpacing.md),
                    Expanded(
                      child: NeoFeatureCard1(
                        icon: Icons.analytics,
                        title: 'Analytics',
                        subtitle: 'Track progress',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),
        ],
      ),
    );
  }
}
