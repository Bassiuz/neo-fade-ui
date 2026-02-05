import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// Typography showcase page showing all text styles from NeoFadeTypography.
class ShowcaseTypographyPage extends StatelessWidget {
  const ShowcaseTypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final typography = theme.typography;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(NeoFadeSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Typography', style: typography.headlineMedium),
          Text(
            'Source Sans 3',
            style: typography.bodySmall.copyWith(color: theme.colors.primary),
          ),
          const SizedBox(height: NeoFadeSpacing.xl),

          // Display styles
          Text('Display', style: typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.sm),
          _buildTypographyItem(
            context,
            name: 'Display Large',
            style: typography.displayLarge,
          ),
          _buildTypographyItem(
            context,
            name: 'Display Medium',
            style: typography.displayMedium,
          ),
          _buildTypographyItem(
            context,
            name: 'Display Small',
            style: typography.displaySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.lg),

          // Headline styles
          Text('Headline', style: typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.sm),
          _buildTypographyItem(
            context,
            name: 'Headline Large',
            style: typography.headlineLarge,
          ),
          _buildTypographyItem(
            context,
            name: 'Headline Medium',
            style: typography.headlineMedium,
          ),
          _buildTypographyItem(
            context,
            name: 'Headline Small',
            style: typography.headlineSmall,
          ),
          const SizedBox(height: NeoFadeSpacing.lg),

          // Title styles
          Text('Title', style: typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.sm),
          _buildTypographyItem(
            context,
            name: 'Title Large',
            style: typography.titleLarge,
          ),
          _buildTypographyItem(
            context,
            name: 'Title Medium',
            style: typography.titleMedium,
          ),
          _buildTypographyItem(
            context,
            name: 'Title Small',
            style: typography.titleSmall,
          ),
          const SizedBox(height: NeoFadeSpacing.lg),

          // Body styles
          Text('Body', style: typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.sm),
          _buildTypographyItem(
            context,
            name: 'Body Large',
            style: typography.bodyLarge,
          ),
          _buildTypographyItem(
            context,
            name: 'Body Medium',
            style: typography.bodyMedium,
          ),
          _buildTypographyItem(
            context,
            name: 'Body Small',
            style: typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.lg),

          // Label styles
          Text('Label', style: typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.sm),
          _buildTypographyItem(
            context,
            name: 'Label Large',
            style: typography.labelLarge,
          ),
          _buildTypographyItem(
            context,
            name: 'Label Medium',
            style: typography.labelMedium,
          ),
          _buildTypographyItem(
            context,
            name: 'Label Small',
            style: typography.labelSmall,
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildTypographyItem(
    BuildContext context, {
    required String name,
    required TextStyle style,
  }) {
    final theme = NeoFadeTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: NeoFadeSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: style),
          const SizedBox(height: 2),
          Text(
            '${style.fontSize?.toInt() ?? 0}px - ${_getWeightName(style.fontWeight)}',
            style: theme.typography.labelSmall.copyWith(
              color: theme.colors.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  String _getWeightName(FontWeight? weight) {
    switch (weight) {
      case FontWeight.w100:
        return 'Thin';
      case FontWeight.w200:
        return 'ExtraLight';
      case FontWeight.w300:
        return 'Light';
      case FontWeight.w400:
        return 'Regular';
      case FontWeight.w500:
        return 'Medium';
      case FontWeight.w600:
        return 'SemiBold';
      case FontWeight.w700:
        return 'Bold';
      case FontWeight.w800:
        return 'ExtraBold';
      case FontWeight.w900:
        return 'Black';
      default:
        return 'Regular';
    }
  }
}
