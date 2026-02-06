import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// Inputs showcase page displaying text fields, checkboxes, switches, sliders, and number selectors.
class ShowcaseInputsPage extends StatefulWidget {
  const ShowcaseInputsPage({super.key});

  @override
  State<ShowcaseInputsPage> createState() => ShowcaseInputsPageState();
}

class ShowcaseInputsPageState extends State<ShowcaseInputsPage> {
  bool checkboxValue = false;
  bool switchValue = false;
  double sliderValue = 0.5;
  int numberValue = 5;

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(NeoFadeSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Inputs', style: theme.typography.headlineMedium),
          const SizedBox(height: NeoFadeSpacing.lg),

          // NeoTextField.outlined Section
          Text('NeoTextField.outlined - Gradient Border on Focus', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'A text field that reveals a gradient border when focused.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          NeoTextField.outlined(hintText: 'Enter your name...'),
          const SizedBox(height: NeoFadeSpacing.md),
          NeoTextField.outlined(hintText: 'Enter your email...'),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // NeoCheckbox.glowBorder() Section
          Text('NeoCheckbox.glowBorder() - Glow Border', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'A checkbox with a glowing border effect when checked.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          Row(
            children: [
              NeoCheckbox.glowBorder(
                value: checkboxValue,
                onChanged: (v) => setState(() => checkboxValue = v),
              ),
              const SizedBox(width: NeoFadeSpacing.md),
              Text(
                checkboxValue ? 'Checked' : 'Unchecked',
                style: theme.typography.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          Row(
            children: [
              NeoCheckbox.glowBorder(
                value: true,
                onChanged: (v) {},
              ),
              const SizedBox(width: NeoFadeSpacing.md),
              Text(
                'Always checked (demo)',
                style: theme.typography.bodyMedium,
              ),
            ],
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // NeoSwitch.ios() Section
          Text('NeoSwitch.ios() - iOS Style', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'An iOS-style switch with gradient track when active.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          Row(
            children: [
              NeoSwitch.ios(
                value: switchValue,
                onChanged: (v) => setState(() => switchValue = v),
              ),
              const SizedBox(width: NeoFadeSpacing.md),
              Text(
                switchValue ? 'On' : 'Off',
                style: theme.typography.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          Row(
            children: [
              NeoSwitch.ios(
                value: true,
                onChanged: (v) {},
              ),
              const SizedBox(width: NeoFadeSpacing.md),
              Text(
                'Always on (demo)',
                style: theme.typography.bodyMedium,
              ),
            ],
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // NeoSlider Section
          Text('NeoSlider - Subtle Gradient', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'A slider with gradient fill and subtle glow effect.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          NeoSlider(
            value: sliderValue,
            onChanged: (v) => setState(() => sliderValue = v),
          ),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'Value: ${(sliderValue * 100).toStringAsFixed(0)}%',
            style: theme.typography.labelSmall,
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // NeoNumberSelector.horizontal() Section
          Text('NeoNumberSelector.horizontal() - Horizontal +/-', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'A number selector with increment/decrement buttons.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          NeoNumberSelector.horizontal(
            value: numberValue,
            onChanged: (v) => setState(() => numberValue = v),
            min: 0,
            max: 20,
          ),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'Range: 0 - 20',
            style: theme.typography.labelSmall,
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),
        ],
      ),
    );
  }
}
