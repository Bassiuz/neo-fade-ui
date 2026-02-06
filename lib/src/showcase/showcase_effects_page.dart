import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// Effects showcase page displaying NeoPulsingGlow wrapper.
class ShowcaseEffectsPage extends StatelessWidget {
  const ShowcaseEffectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(NeoFadeSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Effects', style: theme.typography.headlineMedium),
          const SizedBox(height: NeoFadeSpacing.lg),

          // NeoPulsingGlow Section
          Text('NeoPulsingGlow - Animated Glow Wrapper', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'Wraps any widget with a pulsing glow effect to draw attention.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.xl),

          // Button with glow
          Text('Button with Glow', style: theme.typography.labelMedium),
          const SizedBox(height: NeoFadeSpacing.md),
          Center(
            child: NeoPulsingGlow(
              child: NeoButton.filled(
                label: 'Highlighted Action',
                icon: Icons.star,
                onPressed: () {},
              ),
            ),
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // Card with glow
          Text('Card with Glow', style: theme.typography.labelMedium),
          const SizedBox(height: NeoFadeSpacing.md),
          NeoPulsingGlow(
            child: NeoCard.topBorder(
              padding: const EdgeInsets.all(NeoFadeSpacing.lg),
              child: Row(
                children: [
                  Icon(Icons.local_offer, color: theme.colors.primary),
                  const SizedBox(width: NeoFadeSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Special Offer!', style: theme.typography.titleSmall),
                        Text(
                          'Limited time discount available',
                          style: theme.typography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // Feature card with glow
          Text('Feature Card with Glow', style: theme.typography.labelMedium),
          const SizedBox(height: NeoFadeSpacing.md),
          Row(
            children: [
              Expanded(
                child: NeoFeatureCard.iconTop(
                  icon: Icons.eco,
                  title: 'Normal Card',
                  subtitle: 'Without glow effect',
                ),
              ),
              const SizedBox(width: NeoFadeSpacing.md),
              Expanded(
                child: NeoPulsingGlow(
                  child: NeoFeatureCard.iconTop(
                    icon: Icons.auto_awesome,
                    title: 'Highlighted',
                    subtitle: 'With glow effect',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // Icon with glow
          Text('Icon with Glow', style: theme.typography.labelMedium),
          const SizedBox(height: NeoFadeSpacing.md),
          Center(
            child: NeoPulsingGlow(
              child: Container(
                padding: const EdgeInsets.all(NeoFadeSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colors.primary, theme.colors.secondary],
                  ),
                  borderRadius: NeoFadeRadii.lgRadius,
                ),
                child: Icon(
                  Icons.notifications_active,
                  color: theme.colors.onPrimary,
                  size: 48,
                ),
              ),
            ),
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // Usage notes
          NeoCard.topBorder(
            padding: const EdgeInsets.all(NeoFadeSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Usage Tips', style: theme.typography.titleSmall),
                const SizedBox(height: NeoFadeSpacing.md),
                _buildTipItem(
                  context,
                  Icons.lightbulb_outline,
                  'Use sparingly',
                  'Glow effects work best when used to highlight important elements',
                ),
                const SizedBox(height: NeoFadeSpacing.sm),
                _buildTipItem(
                  context,
                  Icons.wrap_text,
                  'Simple wrapping',
                  'Just wrap any widget with NeoPulsingGlow to add the effect',
                ),
                const SizedBox(height: NeoFadeSpacing.sm),
                _buildTipItem(
                  context,
                  Icons.color_lens,
                  'Theme-aware',
                  'The glow colors automatically match your theme',
                ),
              ],
            ),
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildTipItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final theme = NeoFadeTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: theme.colors.primary, size: 20),
        const SizedBox(width: NeoFadeSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.typography.labelMedium),
              Text(subtitle, style: theme.typography.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
