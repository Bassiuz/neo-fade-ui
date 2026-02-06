import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// Feedback components showcase page.
class ShowcaseFeedbackPage extends StatefulWidget {
  const ShowcaseFeedbackPage({super.key});

  @override
  State<ShowcaseFeedbackPage> createState() => ShowcaseFeedbackPageState();
}

/// State for [ShowcaseFeedbackPage].
class ShowcaseFeedbackPageState extends State<ShowcaseFeedbackPage> {
  double progressValue = 0.6;

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(NeoFadeSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Feedback', style: theme.typography.headlineMedium),
          const SizedBox(height: NeoFadeSpacing.lg),

          // NeoSnackbar section
          Text('NeoSnackbar', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'Glass snackbar with gradient accent line',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          Wrap(
            spacing: NeoFadeSpacing.sm,
            runSpacing: NeoFadeSpacing.sm,
            children: [
              NeoButton.gradientBorder(
                label: 'Info',
                onPressed: () => NeoSnackbar.show(
                  context: context,
                  message: 'This is an info message',
                ),
              ),
              NeoButton.gradientBorder(
                label: 'Success',
                onPressed: () => NeoSnackbar.show(
                  context: context,
                  message: 'Success!',
                  type: NeoSnackbarType.success,
                ),
              ),
              NeoButton.gradientBorder(
                label: 'Warning',
                onPressed: () => NeoSnackbar.show(
                  context: context,
                  message: 'Warning: Please check your input',
                  type: NeoSnackbarType.warning,
                ),
              ),
              NeoButton.gradientBorder(
                label: 'Error',
                onPressed: () => NeoSnackbar.show(
                  context: context,
                  message: 'Something went wrong',
                  type: NeoSnackbarType.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: NeoFadeSpacing.xxl),

          // NeoDialog section
          Text('NeoDialog', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'Glass dialog with gradient border',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          NeoButton.gradientBorder(
            label: 'Show Dialog',
            onPressed: () => NeoDialog.show(
              context: context,
              title: 'Confirm Action',
              content: Text(
                'Are you sure you want to proceed?',
                style: theme.typography.bodyMedium,
              ),
              actions: [
                NeoButton.gradientBorder(
                  label: 'Cancel',
                  onPressed: () => Navigator.pop(context),
                ),
                NeoButton.filled(
                  label: 'Confirm',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: NeoFadeSpacing.xxl),

          // NeoTooltip section
          Text('NeoTooltip', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'Glass tooltip - hover or long press',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          Row(
            children: [
              NeoTooltip(
                message: 'Home page',
                child: Icon(
                  Icons.home,
                  size: 32,
                  color: theme.colors.onSurface,
                ),
              ),
              const SizedBox(width: NeoFadeSpacing.lg),
              NeoTooltip(
                message: 'Settings',
                child: Icon(
                  Icons.settings,
                  size: 32,
                  color: theme.colors.onSurface,
                ),
              ),
              const SizedBox(width: NeoFadeSpacing.lg),
              NeoTooltip(
                message: 'User profile',
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: theme.colors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: NeoFadeSpacing.xxl),

          // NeoProgressIndicator section
          Text('NeoProgressIndicator', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'Linear and circular progress with gradient',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),

          Text('Linear (Determinate)', style: theme.typography.labelMedium),
          const SizedBox(height: NeoFadeSpacing.sm),
          NeoLinearProgressIndicator(value: progressValue),
          const SizedBox(height: NeoFadeSpacing.md),

          Text('Linear (Indeterminate)', style: theme.typography.labelMedium),
          const SizedBox(height: NeoFadeSpacing.sm),
          const NeoLinearProgressIndicator(),
          const SizedBox(height: NeoFadeSpacing.lg),

          Text('Circular', style: theme.typography.labelMedium),
          const SizedBox(height: NeoFadeSpacing.sm),
          Row(
            children: [
              NeoCircularProgressIndicator(value: progressValue),
              const SizedBox(width: NeoFadeSpacing.lg),
              const NeoCircularProgressIndicator(), // Indeterminate
            ],
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),
        ],
      ),
    );
  }
}
