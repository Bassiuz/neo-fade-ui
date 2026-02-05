import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// Buttons showcase page displaying NeoButton1 and NeoButton2 variants.
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

          // NeoButton1 Section
          Text('NeoButton1 - Gradient Filled', style: theme.typography.titleMedium),
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
              NeoButton1(
                label: 'Submit',
                icon: Icons.check,
                onPressed: () {},
              ),
              NeoButton1(
                label: 'Continue',
                icon: Icons.arrow_forward,
                onPressed: () {},
              ),
              NeoButton1(
                label: 'Get Started',
                icon: Icons.rocket_launch,
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // NeoButton2 Section
          Text('NeoButton2 - Gradient Border', style: theme.typography.titleMedium),
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
              NeoButton2(
                label: 'Learn More',
                icon: Icons.info_outline,
                onPressed: () {},
              ),
              NeoButton2(
                label: 'View Details',
                icon: Icons.visibility,
                onPressed: () {},
              ),
              NeoButton2(
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
          NeoCard1(
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
                    NeoButton2(
                      label: 'Cancel',
                      onPressed: () {},
                    ),
                    const SizedBox(width: NeoFadeSpacing.md),
                    NeoButton1(
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
