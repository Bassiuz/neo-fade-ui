import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_colors.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../utils/animation_utils.dart';
import 'neo_bottom_nav_1.dart';

/// Navigation item widget for NeoBottomNavCTA.
class NeoBottomNavCTAItem extends StatelessWidget {
  final NeoBottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final NeoFadeColors colors;

  const NeoBottomNavCTAItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: NeoFadeAnimations.normal,
        padding: const EdgeInsets.symmetric(
          horizontal: NeoFadeSpacing.md,
          vertical: NeoFadeSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 24,
              color: isSelected ? colors.primary : colors.onSurfaceVariant,
            ),
            if (item.label != null) ...[
              const SizedBox(height: NeoFadeSpacing.xxs),
              Text(
                item.label!,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
