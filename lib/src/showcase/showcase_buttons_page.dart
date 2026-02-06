import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// Buttons showcase page displaying NeoButton.filled() and NeoButton.gradientBorder() variants.
class ShowcaseButtonsPage extends StatelessWidget {
  const ShowcaseButtonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(NeoFadeSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Buttons', style: theme.typography.headlineMedium),
          const SizedBox(height: NeoFadeSpacing.lg),

          // NeoButton.filled() Section
          Text('NeoButton.filled() - Gradient Filled', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'A button with gradient background fill for primary actions.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          Wrap(
            spacing: NeoFadeSpacing.md,
            runSpacing: NeoFadeSpacing.md,
            children: [
              NeoButton.filled(
                label: 'Submit',
                icon: Icons.check,
                onPressed: () {},
              ),
              NeoButton.filled(
                label: 'Continue',
                icon: Icons.arrow_forward,
                onPressed: () {},
              ),
              NeoButton.filled(
                label: 'Get Started',
                icon: Icons.rocket_launch,
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // NeoButton.gradientBorder() Section
          Text('NeoButton.gradientBorder() - Gradient Border', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'A button with gradient border outline for secondary actions.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          Wrap(
            spacing: NeoFadeSpacing.md,
            runSpacing: NeoFadeSpacing.md,
            children: [
              NeoButton.gradientBorder(
                label: 'Learn More',
                icon: Icons.info_outline,
                onPressed: () {},
              ),
              NeoButton.gradientBorder(
                label: 'View Details',
                icon: Icons.visibility,
                onPressed: () {},
              ),
              NeoButton.gradientBorder(
                label: 'Cancel',
                icon: Icons.close,
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // Combined Example
          Text('Button Combinations', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'Example of using both button types together.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          NeoCard.topBorder(
            padding: const EdgeInsets.all(NeoFadeSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Confirm your action', style: theme.typography.titleSmall),
                const SizedBox(height: NeoFadeSpacing.sm),
                Text(
                  'Are you sure you want to proceed with this operation?',
                  style: theme.typography.bodyMedium,
                ),
                const SizedBox(height: NeoFadeSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    NeoButton.gradientBorder(
                      label: 'Cancel',
                      onPressed: () {},
                    ),
                    const SizedBox(width: NeoFadeSpacing.md),
                    NeoButton.filled(
                      label: 'Confirm',
                      icon: Icons.check,
                      onPressed: () {},
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
