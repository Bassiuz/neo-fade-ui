import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_colors.dart';
import '../../theme/neo_fade_glass_properties.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_typography.dart';

/// Delegate for NeoSliverAppBar.
class NeoSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget? leading;
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool centerTitle;
  final double expandedHeight;
  final double collapsedHeight;
  final Widget? flexibleSpace;
  final double gradientBorderHeight;
  final NeoFadeColors colors;
  final NeoFadeGlassProperties glass;
  final NeoFadeTypography typography;

  NeoSliverAppBarDelegate({
    this.leading,
    this.title,
    this.titleWidget,
    this.actions,
    this.centerTitle = false,
    required this.expandedHeight,
    required this.collapsedHeight,
    this.flexibleSpace,
    required this.gradientBorderHeight,
    required this.colors,
    required this.glass,
    required this.typography,
  });

  @override
  double get minExtent => collapsedHeight + gradientBorderHeight;

  @override
  double get maxExtent => expandedHeight + gradientBorderHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final effectiveBlur = glass.blur * (0.5 + progress * 0.5);

    Widget? titleContent;
    if (titleWidget != null) {
      titleContent = titleWidget;
    } else if (title != null) {
      titleContent = Text(
        title!,
        style: typography.titleLarge.copyWith(
          color: colors.onSurface,
        ),
      );
    }

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: effectiveBlur,
          sigmaY: effectiveBlur,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface.withValues(
              alpha: glass.tintOpacity * (0.5 + progress * 0.5),
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (flexibleSpace != null)
                Opacity(
                  opacity: 1 - progress,
                  child: flexibleSpace,
                ),
              Positioned(
                left: 0,
                right: 0,
                bottom: gradientBorderHeight,
                height: collapsedHeight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: NeoFadeSpacing.lg),
                  child: Row(
                    children: [
                      if (leading != null) ...[
                        leading!,
                        const SizedBox(width: NeoFadeSpacing.md),
                      ],
                      if (centerTitle) const Spacer(),
                      if (titleContent != null) ...[
                        if (!centerTitle)
                          Expanded(
                            child: Opacity(
                              opacity: progress,
                              child: titleContent,
                            ),
                          )
                        else
                          Opacity(
                            opacity: progress,
                            child: titleContent,
                          ),
                      ] else if (!centerTitle)
                        const Spacer(),
                      if (centerTitle) const Spacer(),
                      if (actions != null) ...[
                        for (int i = 0; i < actions!.length; i++) ...[
                          if (i > 0) const SizedBox(width: NeoFadeSpacing.xs),
                          actions![i],
                        ],
                      ],
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: gradientBorderHeight,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colors.primary,
                        colors.secondary,
                        colors.tertiary,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(NeoSliverAppBarDelegate oldDelegate) {
    return leading != oldDelegate.leading ||
        title != oldDelegate.title ||
        titleWidget != oldDelegate.titleWidget ||
        actions != oldDelegate.actions ||
        centerTitle != oldDelegate.centerTitle ||
        expandedHeight != oldDelegate.expandedHeight ||
        collapsedHeight != oldDelegate.collapsedHeight ||
        flexibleSpace != oldDelegate.flexibleSpace ||
        gradientBorderHeight != oldDelegate.gradientBorderHeight;
  }
}
