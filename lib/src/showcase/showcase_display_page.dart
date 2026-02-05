import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// Display components showcase page.
class ShowcaseDisplayPage extends StatelessWidget {
  const ShowcaseDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(NeoFadeSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Display', style: theme.typography.headlineMedium),
          const SizedBox(height: NeoFadeSpacing.lg),

          // NeoBadge section
          Text('NeoBadge', style: theme.typography.titleMedium),
          Text(
            'Notification badges with count or dot indicator',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          Row(
            children: [
              NeoBadge(count: 5, child: Icon(Icons.notifications, size: 32)),
              const SizedBox(width: NeoFadeSpacing.lg),
              NeoBadge(count: 99, child: Icon(Icons.mail, size: 32)),
              const SizedBox(width: NeoFadeSpacing.lg),
              NeoBadge(showDot: true, child: Icon(Icons.chat, size: 32)),
            ],
          ),
          const SizedBox(height: NeoFadeSpacing.xl),

          // NeoChip section
          Text('NeoChip', style: theme.typography.titleMedium),
          Text(
            'Glass chips with gradient border on selection',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          Wrap(
            spacing: NeoFadeSpacing.sm,
            runSpacing: NeoFadeSpacing.sm,
            children: [
              NeoChip(label: 'Default'),
              NeoChip(label: 'Selected', selected: true),
              NeoChip(label: 'With Icon', icon: Icons.star),
              NeoChip(label: 'Deletable', onDelete: () {}),
            ],
          ),
          const SizedBox(height: NeoFadeSpacing.xl),

          // NeoAvatar section
          Text('NeoAvatar', style: theme.typography.titleMedium),
          Text('Avatar with gradient ring', style: theme.typography.bodySmall),
          const SizedBox(height: NeoFadeSpacing.md),
          Row(
            children: [
              NeoAvatar(initials: 'JD'),
              const SizedBox(width: NeoFadeSpacing.md),
              NeoAvatar(icon: Icons.person),
              const SizedBox(width: NeoFadeSpacing.md),
              NeoAvatar(initials: 'AB', size: 48),
            ],
          ),
          const SizedBox(height: NeoFadeSpacing.xl),

          // NeoListTile section
          Text('NeoListTile', style: theme.typography.titleMedium),
          Text(
            'List item with glass background',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          NeoListTile(
            leading: NeoAvatar(initials: 'JD', size: 40),
            title: 'John Doe',
            subtitle: 'johndoe@example.com',
            trailing: Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const SizedBox(height: NeoFadeSpacing.sm),
          NeoListTile(
            leading: Icon(Icons.settings, size: 24),
            title: 'Settings',
            onTap: () {},
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),
        ],
      ),
    );
  }
}
