import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../foundation/gradient_border.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_dialog_route.dart';

/// Glass dialog/modal with gradient border.
///
/// A modal dialog with the Neo Fade glass effect, featuring a gradient
/// border and customizable content, title, and actions.
class NeoDialog extends StatelessWidget {
  final String? title;
  final Widget? content;
  final List<Widget>? actions;
  final bool barrierDismissible;
  final double? width;

  const NeoDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.barrierDismissible = true,
    this.width,
  });

  /// Shows the dialog.
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    Widget? content,
    List<Widget>? actions,
    bool barrierDismissible = true,
    double? width,
  }) {
    return Navigator.of(context).push<T>(
      NeoDialogRoute<T>(
        builder: (context) => NeoDialog(
          title: title,
          content: content,
          actions: actions,
          barrierDismissible: barrierDismissible,
          width: width,
        ),
        dismissible: barrierDismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(NeoFadeRadii.dialog),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: glass.blur,
            sigmaY: glass.blur,
          ),
          child: CustomPaint(
            painter: GradientBorderPainter(
              colors: [colors.primary, colors.secondary, colors.tertiary],
              borderWidth: 1.5,
              borderRadius: BorderRadius.circular(NeoFadeRadii.dialog),
              bottomOnly: false,
            ),
            child: Container(
              width: width ?? 320,
              constraints: const BoxConstraints(maxWidth: 560),
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: glass.tintOpacity + 0.15),
                borderRadius: BorderRadius.circular(NeoFadeRadii.dialog),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        NeoFadeSpacing.dialogPadding,
                        NeoFadeSpacing.dialogPadding,
                        NeoFadeSpacing.dialogPadding,
                        NeoFadeSpacing.sm,
                      ),
                      child: Text(
                        title!,
                        style: theme.typography.titleLarge.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                  if (content != null)
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          NeoFadeSpacing.dialogPadding,
                          title != null ? 0 : NeoFadeSpacing.dialogPadding,
                          NeoFadeSpacing.dialogPadding,
                          NeoFadeSpacing.dialogPadding,
                        ),
                        child: content!,
                      ),
                    ),
                  if (actions != null && actions!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        NeoFadeSpacing.lg,
                        0,
                        NeoFadeSpacing.lg,
                        NeoFadeSpacing.lg,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          for (int i = 0; i < actions!.length; i++) ...[
                            if (i > 0) const SizedBox(width: NeoFadeSpacing.sm),
                            actions![i],
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
