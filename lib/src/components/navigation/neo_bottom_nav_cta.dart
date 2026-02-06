import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_bottom_nav_cta_item.dart';
import 'neo_bottom_nav_item.dart';
import 'neo_nav_cta_button.dart';

/// Bottom navigation bar with animated floating CTA button.
///
/// Features:
/// - Glass nav bar with ClipRRect + BackdropFilter
/// - Items split: left half before center, right half after center
/// - Gap in the middle for CTA button that floats above and clips the nav bar
/// - CTA: 56x56 rounded square (borderRadius: 16), gradient fill primary→secondary
/// - CTA has glow effect with boxShadow
/// - Idle: Floating animation (subtle up/down movement, 2s cycle)
/// - Press: Scale down to 0.9 + slight rotation
class NeoBottomNavCTA extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<NeoBottomNavItem> items;
  final VoidCallback onCenterPressed;
  final IconData centerIcon;
  final bool animated;

  /// Optional height for the navigation bar. Defaults to 80.
  final double? height;

  /// Optional size for the CTA button. Defaults to 56.
  final double? ctaSize;

  /// Optional border radius for the CTA button. Defaults to NeoFadeRadii.lg.
  final double? ctaBorderRadius;

  /// Optional border radius for the navigation bar. Defaults to NeoFadeRadii.xl.
  final double? navBorderRadius;

  /// Optional overlap amount for the CTA button above the nav bar. Defaults to 8.
  final double? ctaOverlap;

  const NeoBottomNavCTA({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.items,
    required this.onCenterPressed,
    this.centerIcon =
        const IconData(0xe3b0, fontFamily: 'MaterialIcons'), // camera icon
    this.animated = true,
    this.height,
    this.ctaSize,
    this.ctaBorderRadius,
    this.navBorderRadius,
    this.ctaOverlap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final leftItems = items.take((items.length / 2).floor()).toList();
    final rightItems = items.skip((items.length / 2).floor()).toList();

    // CTA button size and positioning with effective defaults
    final effectiveCtaSize = ctaSize ?? 56.0;
    final effectiveHeight = height ?? 80.0;
    final effectiveCtaBorderRadius = ctaBorderRadius ?? NeoFadeRadii.lg;
    final effectiveNavBorderRadius = navBorderRadius ?? NeoFadeRadii.xl;

    // Position CTA so only ~12% sticks above the nav bar
    final stickOutAmount = effectiveCtaSize * 0.12;

    return SizedBox(
      height: effectiveHeight + stickOutAmount,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Glass nav bar
          ClipRRect(
            borderRadius: BorderRadius.circular(effectiveNavBorderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
              child: Container(
                height: effectiveHeight,
                padding: const EdgeInsets.symmetric(
                  horizontal: NeoFadeSpacing.sm,
                  vertical: NeoFadeSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: glass.tintOpacity),
                  borderRadius: BorderRadius.circular(effectiveNavBorderRadius),
                  border: Border.all(
                    color: colors.border.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Left items
                    ...leftItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isSelected = index == selectedIndex;
                      return NeoBottomNavCTAItem(
                        item: item,
                        isSelected: isSelected,
                        onTap: () => onIndexChanged(index),
                        colors: colors,
                      );
                    }),

                    // Gap for CTA button
                    SizedBox(width: effectiveCtaSize + NeoFadeSpacing.md),

                    // Right items
                    ...rightItems.asMap().entries.map((entry) {
                      final index = entry.key + leftItems.length;
                      final item = entry.value;
                      final isSelected = index == selectedIndex;
                      return NeoBottomNavCTAItem(
                        item: item,
                        isSelected: isSelected,
                        onTap: () => onIndexChanged(index),
                        colors: colors,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // Floating CTA button (positioned to overlap the nav bar)
          Positioned(
            bottom: effectiveHeight - effectiveCtaSize + stickOutAmount,
            child: NeoNavCTAButton(
              icon: centerIcon,
              onPressed: onCenterPressed,
              colors: colors,
              size: effectiveCtaSize,
              borderRadius: effectiveCtaBorderRadius,
              animated: animated,
            ),
          ),
        ],
      ),
    );
  }
}
