import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// Selectors showcase page displaying segmented controls.
class ShowcaseSelectorsPage extends StatefulWidget {
  const ShowcaseSelectorsPage({super.key});

  @override
  State<ShowcaseSelectorsPage> createState() => ShowcaseSelectorsPageState();
}

class ShowcaseSelectorsPageState extends State<ShowcaseSelectorsPage> {
  String segmentedValue = 'day';
  String segmentedIconsValue = 'list';
  String periodValue = 'monthly';

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(NeoFadeSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selectors', style: theme.typography.headlineMedium),
          const SizedBox(height: NeoFadeSpacing.lg),

          // NeoSegmentedControl.sliding Section
          Text('NeoSegmentedControl.sliding - Sliding Gradient', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'A segmented control with a sliding gradient selection indicator.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          NeoSegmentedControl.sliding<String>(
            selectedValue: segmentedValue,
            onValueChanged: (v) => setState(() => segmentedValue = v),
            segments: const [
              NeoSegment(value: 'day', label: 'Day'),
              NeoSegment(value: 'week', label: 'Week'),
              NeoSegment(value: 'month', label: 'Month'),
            ],
          ),
          const SizedBox(height: NeoFadeSpacing.sm),
          Text(
            'Selected: ${segmentedValue.toUpperCase()}',
            style: theme.typography.labelSmall,
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // Another NeoSegmentedControl.sliding example
          Text('NeoSegmentedControl.sliding - Different Options', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'The same control with different segment options.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          NeoSegmentedControl.sliding<String>(
            selectedValue: periodValue,
            onValueChanged: (v) => setState(() => periodValue = v),
            segments: const [
              NeoSegment(value: 'monthly', label: 'Monthly'),
              NeoSegment(value: 'yearly', label: 'Yearly'),
            ],
          ),
          const SizedBox(height: NeoFadeSpacing.sm),
          Text(
            'Selected: ${periodValue.toUpperCase()}',
            style: theme.typography.labelSmall,
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // NeoSegmentedControlIcons Section
          Text('NeoSegmentedControlIcons - Icons Above Labels', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'A segmented control with icons displayed above the labels.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          NeoSegmentedControlIcons<String>(
            selectedValue: segmentedIconsValue,
            onValueChanged: (v) => setState(() => segmentedIconsValue = v),
            segments: const [
              NeoSegment(value: 'list', label: 'List', icon: Icons.list),
              NeoSegment(value: 'grid', label: 'Grid', icon: Icons.grid_view),
              NeoSegment(value: 'card', label: 'Card', icon: Icons.view_agenda),
            ],
          ),
          const SizedBox(height: NeoFadeSpacing.sm),
          Text(
            'View mode: ${segmentedIconsValue.toUpperCase()}',
            style: theme.typography.labelSmall,
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // Usage Example
          Text('Usage Example', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'Combining segmented controls in a real UI context.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          NeoCard.topBorder(
            padding: const EdgeInsets.all(NeoFadeSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('View Settings', style: theme.typography.titleSmall),
                const SizedBox(height: NeoFadeSpacing.md),
                Text('Time Period', style: theme.typography.labelMedium),
                const SizedBox(height: NeoFadeSpacing.sm),
                NeoSegmentedControl.sliding<String>(
                  selectedValue: segmentedValue,
                  onValueChanged: (v) => setState(() => segmentedValue = v),
                  segments: const [
                    NeoSegment(value: 'day', label: 'Day'),
                    NeoSegment(value: 'week', label: 'Week'),
                    NeoSegment(value: 'month', label: 'Month'),
                  ],
                ),
                const SizedBox(height: NeoFadeSpacing.lg),
                Text('Display Mode', style: theme.typography.labelMedium),
                const SizedBox(height: NeoFadeSpacing.sm),
                NeoSegmentedControlIcons<String>(
                  selectedValue: segmentedIconsValue,
                  onValueChanged: (v) => setState(() => segmentedIconsValue = v),
                  segments: const [
                    NeoSegment(value: 'list', label: 'List', icon: Icons.list),
                    NeoSegment(value: 'grid', label: 'Grid', icon: Icons.grid_view),
                    NeoSegment(value: 'card', label: 'Card', icon: Icons.view_agenda),
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
