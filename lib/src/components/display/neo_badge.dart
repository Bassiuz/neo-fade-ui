import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';

/// Small notification badge with gradient.
///
/// A badge that displays a count or indicator, featuring the Neo Fade
/// gradient style for visual emphasis.
class NeoBadge extends StatelessWidget {
  final String? label;
  final int? count;
  final bool showDot;
  final Widget? child;
  final NeoBadgePosition position;
  final Color? overrideColor;

  const NeoBadge({
    super.key,
    this.label,
    this.count,
    this.showDot = false,
    this.child,
    this.position = NeoBadgePosition.topRight,
    this.overrideColor,
  });

  const NeoBadge.count({
    super.key,
    required int this.count,
    this.child,
    this.position = NeoBadgePosition.topRight,
    this.overrideColor,
  })  : label = null,
        showDot = false;

  const NeoBadge.dot({
    super.key,
    this.child,
    this.position = NeoBadgePosition.topRight,
    this.overrideColor,
  })  : label = null,
        count = null,
        showDot = true;

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;

    final displayText = label ?? (count != null ? (count! > 99 ? '99+' : count.toString()) : null);
    final isDot = showDot || displayText == null;

    final badgeWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: isDot
          ? null
          : const EdgeInsets.symmetric(
              horizontal: NeoFadeSpacing.xs + 2,
              vertical: 1,
            ),
      constraints: isDot
          ? null
          : const BoxConstraints(minWidth: 18, minHeight: 18),
      width: isDot ? 10 : null,
      height: isDot ? 10 : null,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: overrideColor != null
              ? [overrideColor!, overrideColor!]
              : [colors.primary, colors.secondary],
        ),
        borderRadius: BorderRadius.circular(isDot ? 5 : 9),
        boxShadow: [
          BoxShadow(
            color: (overrideColor ?? colors.primary).withValues(alpha: 0.4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: isDot
          ? null
          : Center(
              child: Text(
                displayText,
                style: theme.typography.labelSmall.copyWith(
                  color: colors.onPrimary,
                  fontSize: 10,
                  height: 1.2,
                ),
              ),
            ),
    );

    if (child == null) {
      return badgeWidget;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned(
          top: position == NeoBadgePosition.topRight ||
                  position == NeoBadgePosition.topLeft
              ? isDot ? -3 : -6
              : null,
          bottom: position == NeoBadgePosition.bottomRight ||
                  position == NeoBadgePosition.bottomLeft
              ? isDot ? -3 : -6
              : null,
          right: position == NeoBadgePosition.topRight ||
                  position == NeoBadgePosition.bottomRight
              ? isDot ? -3 : -6
              : null,
          left: position == NeoBadgePosition.topLeft ||
                  position == NeoBadgePosition.bottomLeft
              ? isDot ? -3 : -6
              : null,
          child: badgeWidget,
        ),
      ],
    );
  }
}

/// Position of the badge relative to its child.
enum NeoBadgePosition {
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
}
