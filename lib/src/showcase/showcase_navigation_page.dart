import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// Navigation showcase page displaying NeoBottomNavCTA.
class ShowcaseNavigationPage extends StatefulWidget {
  const ShowcaseNavigationPage({super.key});

  @override
  State<ShowcaseNavigationPage> createState() => ShowcaseNavigationPageState();
}

class ShowcaseNavigationPageState extends State<ShowcaseNavigationPage> {
  int bottomNavIndex = 0;
  bool ctaAnimated = true;

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(NeoFadeSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Navigation', style: theme.typography.headlineMedium),
          const SizedBox(height: NeoFadeSpacing.lg),

          // NeoBottomNavCTA Section
          Text('NeoBottomNavCTA - Floating CTA Button', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'A bottom navigation bar with a floating center action button.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          Row(
            children: [
              Text('Animation', style: theme.typography.labelMedium),
              const Spacer(),
              NeoSwitch2(
                value: ctaAnimated,
                onChanged: (v) => setState(() => ctaAnimated = v),
              ),
            ],
          ),
          const SizedBox(height: NeoFadeSpacing.md),

          // Preview container
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: theme.colors.surface.withValues(alpha: 0.5),
              borderRadius: NeoFadeRadii.lgRadius,
              border: Border.all(color: theme.colors.border),
            ),
            child: Stack(
              children: [
                // Content area
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIconForIndex(bottomNavIndex),
                        size: 48,
                        color: theme.colors.primary,
                      ),
                      const SizedBox(height: NeoFadeSpacing.sm),
                      Text(
                        _getLabelForIndex(bottomNavIndex),
                        style: theme.typography.titleSmall,
                      ),
                    ],
                  ),
                ),
                // Bottom nav
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 360),
                      child: NeoBottomNavCTA(
                        selectedIndex: bottomNavIndex,
                        onIndexChanged: (i) => setState(() => bottomNavIndex = i),
                        items: const [
                          NeoBottomNavItem(icon: Icons.home, label: 'Home'),
                          NeoBottomNavItem(icon: Icons.search, label: 'Search'),
                          NeoBottomNavItem(icon: Icons.favorite, label: 'Favorites'),
                          NeoBottomNavItem(icon: Icons.person, label: 'Profile'),
                        ],
                        onCenterPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Center button pressed!'),
                              backgroundColor: theme.colors.primary,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        centerIcon: Icons.add,
                        animated: ctaAnimated,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: NeoFadeSpacing.lg),

          // Features list
          NeoCard1(
            padding: const EdgeInsets.all(NeoFadeSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Features', style: theme.typography.titleSmall),
                const SizedBox(height: NeoFadeSpacing.md),
                _buildFeatureItem(
                  context,
                  Icons.center_focus_strong,
                  'Floating CTA',
                  'Center button rises above the nav bar',
                ),
                const SizedBox(height: NeoFadeSpacing.sm),
                _buildFeatureItem(
                  context,
                  Icons.gradient,
                  'Gradient Background',
                  'Glass-style background with gradient',
                ),
                const SizedBox(height: NeoFadeSpacing.sm),
                _buildFeatureItem(
                  context,
                  Icons.animation,
                  'Smooth Animations',
                  'Selection indicator animates between items',
                ),
                const SizedBox(height: NeoFadeSpacing.sm),
                _buildFeatureItem(
                  context,
                  Icons.touch_app,
                  'Interactive',
                  'Tap items to switch or center for action',
                ),
              ],
            ),
          ),

          const SizedBox(height: NeoFadeSpacing.xl),

          // NeoFloatingActions Section
          Text('NeoFloatingActions - Floating Action Bar', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'A minimal liquid glass bar with quick action buttons.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),

          // Preview container
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: theme.colors.surface.withValues(alpha: 0.5),
              borderRadius: NeoFadeRadii.lgRadius,
              border: Border.all(color: theme.colors.border),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text('Content Area', style: theme.typography.bodySmall),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: NeoFloatingActions(
                      items: [
                        NeoFloatingActionItem(
                          icon: Icons.home,
                          onPressed: () {},
                        ),
                        NeoFloatingActionItem(
                          icon: Icons.search,
                          onPressed: () {},
                        ),
                        NeoFloatingActionItem(
                          icon: Icons.add,
                          onPressed: () {},
                        ),
                        NeoFloatingActionItem(
                          icon: Icons.favorite,
                          onPressed: () {},
                        ),
                        NeoFloatingActionItem(
                          icon: Icons.person,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: NeoFadeSpacing.lg),

          const SizedBox(height: NeoFadeSpacing.xxl),
        ],
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.search;
      case 2:
        return Icons.favorite;
      case 3:
        return Icons.person;
      default:
        return Icons.home;
    }
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Search';
      case 2:
        return 'Favorites';
      case 3:
        return 'Profile';
      default:
        return 'Home';
    }
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final theme = NeoFadeTheme.of(context);
    return Row(
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
