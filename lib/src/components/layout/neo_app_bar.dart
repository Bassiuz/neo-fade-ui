import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_spacing.dart';
import 'neo_sliver_app_bar_delegate.dart';
import '../../theme/neo_fade_theme.dart';

/// Glass app bar with gradient bottom border.
///
/// An app bar with the Neo Fade glass effect, featuring a gradient
/// accent line at the bottom and customizable leading/trailing widgets.
class NeoAppBar extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool centerTitle;
  final double height;
  final double gradientBorderHeight;
  final EdgeInsetsGeometry? padding;

  const NeoAppBar({
    super.key,
    this.leading,
    this.title,
    this.titleWidget,
    this.actions,
    this.centerTitle = false,
    this.height = 56,
    this.gradientBorderHeight = 2,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final effectivePadding = padding ??
        const EdgeInsets.symmetric(horizontal: NeoFadeSpacing.lg);

    Widget? titleContent;
    if (titleWidget != null) {
      titleContent = titleWidget;
    } else if (title != null) {
      titleContent = Text(
        title!,
        style: theme.typography.titleLarge.copyWith(
          color: colors.onSurface,
        ),
      );
    }

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: glass.blur,
          sigmaY: glass.blur,
        ),
        child: Container(
          height: height + gradientBorderHeight,
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: glass.tintOpacity),
            border: Border(
              bottom: BorderSide(
                color: colors.border.withValues(alpha: 0.1),
                width: 0,
              ),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: effectivePadding,
                  child: Row(
                    children: [
                      if (leading != null) ...[
                        leading!,
                        const SizedBox(width: NeoFadeSpacing.md),
                      ],
                      if (centerTitle) const Spacer(),
                      if (titleContent != null) ...[
                        if (!centerTitle)
                          Expanded(child: titleContent)
                        else
                          titleContent,
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
              Container(
                height: gradientBorderHeight,
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
            ],
          ),
        ),
      ),
    );
  }
}

/// A sliver version of NeoAppBar for use in CustomScrollView.
class NeoSliverAppBar extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool centerTitle;
  final double expandedHeight;
  final double collapsedHeight;
  final Widget? flexibleSpace;
  final bool pinned;
  final bool floating;
  final double gradientBorderHeight;

  const NeoSliverAppBar({
    super.key,
    this.leading,
    this.title,
    this.titleWidget,
    this.actions,
    this.centerTitle = false,
    this.expandedHeight = 200,
    this.collapsedHeight = 56,
    this.flexibleSpace,
    this.pinned = true,
    this.floating = false,
    this.gradientBorderHeight = 2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: NeoSliverAppBarDelegate(
        leading: leading,
        title: title,
        titleWidget: titleWidget,
        actions: actions,
        centerTitle: centerTitle,
        expandedHeight: expandedHeight,
        collapsedHeight: collapsedHeight,
        flexibleSpace: flexibleSpace,
        gradientBorderHeight: gradientBorderHeight,
        colors: colors,
        glass: glass,
        typography: theme.typography,
      ),
    );
  }
}
