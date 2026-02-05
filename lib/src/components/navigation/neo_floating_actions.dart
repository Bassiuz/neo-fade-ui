import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_floating_action_button.dart';
import 'neo_floating_action_item.dart';

/// A liquid glass floating action bar with small action buttons.
class NeoFloatingActions extends StatelessWidget {
  final List<NeoFloatingActionItem> items;
  final double? height;
  final double? iconSize;
  final double? spacing;
  final double? borderRadius;
  final EdgeInsets? margin;

  const NeoFloatingActions({
    super.key,
    required this.items,
    this.height,
    this.iconSize,
    this.spacing,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final effectiveHeight = height ?? 56.0;
    final effectiveIconSize = iconSize ?? 22.0;
    final effectiveSpacing = spacing ?? NeoFadeSpacing.sm;
    final effectiveBorderRadius = borderRadius ?? NeoFadeRadii.xl;
    final effectiveMargin = margin ?? const EdgeInsets.all(NeoFadeSpacing.md);

    return Padding(
      padding: effectiveMargin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: glass.blur * 1.5,
            sigmaY: glass.blur * 1.5,
          ),
          child: Container(
            height: effectiveHeight,
            padding: const EdgeInsets.symmetric(horizontal: NeoFadeSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.surface.withValues(alpha: glass.tintOpacity + 0.15),
                  colors.surface.withValues(alpha: glass.tintOpacity + 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              border: Border.all(
                color: colors.border.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : effectiveSpacing,
                  ),
                  child: NeoFloatingActionButton(
                    icon: item.icon,
                    onPressed: item.onPressed,
                    colors: colors,
                    iconSize: effectiveIconSize,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
