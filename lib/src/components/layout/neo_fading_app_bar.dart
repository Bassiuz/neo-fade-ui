import 'package:flutter/material.dart';

import '../../theme/neo_fade_theme.dart';

/// A full-bleed title bar that fades into the background instead of sitting on
/// it as a panel.
///
/// The backing runs from transparent at the very top — so the status bar and
/// the dynamic island sit on whatever is behind, typically a [MeshBackground]
/// — down to solid behind the title, and ends on a hard edge carrying the same
/// gradient hairline a card has. With no border and no panel, a two-line title
/// simply makes the bar taller rather than heavier.
///
/// Use [NeoAppBar] instead when you want a distinct bar with its own surface.
///
/// This applies its own top inset from [MediaQuery], so do **not** wrap it in
/// a `SafeArea`:
///
/// ```dart
/// Column(
///   children: [
///     const NeoFadingAppBar(title: 'Library'),
///     Expanded(child: body),
///   ],
/// )
/// ```
class NeoFadingAppBar extends StatelessWidget {
  /// Shown at up to two lines, then ellipsised.
  final String title;

  /// Usually a back button. Sits before the title.
  final Widget? leading;

  /// Trailing actions, laid out after the title.
  final List<Widget>? actions;

  /// How opaque the backing gets behind the title. Lower it over busy
  /// artwork, raise it when body text scrolls underneath.
  final double opacity;

  /// Height of the gradient hairline along the bottom edge. Zero removes it.
  final double borderHeight;

  const NeoFadingAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.opacity = 0.86,
    this.borderHeight = 2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final backing = colors.surface.withValues(alpha: opacity);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [backing.withValues(alpha: 0), backing, backing],
              stops: const [0, 0.7, 1],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
            child: Row(
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 10)],
                Expanded(
                  child: Padding(
                    // Without a button beside it the title would otherwise
                    // start hard against the screen edge.
                    padding: EdgeInsets.only(left: leading == null ? 6 : 0),
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.typography.headlineSmall,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ...?actions,
              ],
            ),
          ),
        ),
        if (borderHeight > 0)
          Container(
            height: borderHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.primary, colors.secondary, colors.tertiary],
              ),
            ),
          ),
      ],
    );
  }
}
