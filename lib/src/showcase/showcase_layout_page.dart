import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// Layout components showcase page.
class ShowcaseLayoutPage extends StatelessWidget {
  const ShowcaseLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(NeoFadeSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Layout', style: theme.typography.headlineMedium),
          const SizedBox(height: NeoFadeSpacing.lg),

          // NeoAppBar section
          Text('NeoAppBar', style: theme.typography.titleMedium),
          Text(
            'Glass app bar with gradient bottom border',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),

          // Preview container for app bar
          Container(
            height: 120,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: NeoFadeRadii.lgRadius,
              border: Border.all(color: theme.colors.border),
            ),
            child: Column(
              children: [
                NeoAppBar(
                  title: 'App Title',
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {},
                  ),
                  actions: [
                    IconButton(icon: Icon(Icons.search), onPressed: () {}),
                    IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Content area',
                      style: theme.typography.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: NeoFadeSpacing.xl),

          // NeoDivider section
          Text('NeoDivider', style: theme.typography.titleMedium),
          Text(
            'Subtle gradient divider line',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),

          // Horizontal divider
          Text('Horizontal', style: theme.typography.labelMedium),
          const SizedBox(height: NeoFadeSpacing.sm),
          const NeoDivider(),
          const SizedBox(height: NeoFadeSpacing.lg),

          // Labeled divider
          Text('Labeled', style: theme.typography.labelMedium),
          const SizedBox(height: NeoFadeSpacing.sm),
          NeoDivider(label: 'OR'),
          const SizedBox(height: NeoFadeSpacing.lg),

          // Vertical divider demo
          Text('Vertical', style: theme.typography.labelMedium),
          const SizedBox(height: NeoFadeSpacing.sm),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Left', style: theme.typography.bodyMedium),
                const SizedBox(width: NeoFadeSpacing.md),
                SizedBox(
                  height: 30,
                  child: NeoDivider.vertical(),
                ),
                const SizedBox(width: NeoFadeSpacing.md),
                Text('Right', style: theme.typography.bodyMedium),
              ],
            ),
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),
        ],
      ),
    );
  }
}
