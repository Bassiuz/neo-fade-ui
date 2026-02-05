import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_snackbar_overlay.dart';

/// Glass snackbar with gradient accent line.
///
/// A notification bar with the Neo Fade glass effect, featuring
/// a gradient accent line at the bottom and optional action button.
class NeoSnackbar extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;
  final NeoSnackbarType type;

  const NeoSnackbar({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    this.type = NeoSnackbarType.info,
  });

  /// Shows the snackbar as an overlay.
  static OverlayEntry show({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    NeoSnackbarType type = NeoSnackbarType.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => NeoSnackbarOverlay(
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
        type: type,
        duration: duration,
        onDismiss: () => entry.remove(),
      ),
    );

    Overlay.of(context).insert(entry);
    return entry;
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final accentColors = switch (type) {
      NeoSnackbarType.info => [colors.primary, colors.secondary],
      NeoSnackbarType.success => [colors.success, colors.primary],
      NeoSnackbarType.warning => [colors.warning, colors.secondary],
      NeoSnackbarType.error => [colors.error, colors.warning],
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(NeoFadeRadii.md),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: glass.blur,
          sigmaY: glass.blur,
        ),
        child: Container(
          constraints: const BoxConstraints(minWidth: 288, maxWidth: 568),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: glass.tintOpacity + 0.1),
            borderRadius: BorderRadius.circular(NeoFadeRadii.md),
            boxShadow: [
              BoxShadow(
                color: accentColors[0].withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  NeoFadeSpacing.lg,
                  NeoFadeSpacing.md,
                  NeoFadeSpacing.md,
                  NeoFadeSpacing.md,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        message,
                        style: theme.typography.bodyMedium.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                    if (actionLabel != null) ...[
                      const SizedBox(width: NeoFadeSpacing.sm),
                      GestureDetector(
                        onTap: onAction,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text(
                            actionLabel!,
                            style: theme.typography.labelLarge.copyWith(
                              color: colors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (onDismiss != null) ...[
                      const SizedBox(width: NeoFadeSpacing.xs),
                      GestureDetector(
                        onTap: onDismiss,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Icon(
                            const IconData(0xe5cd,
                                fontFamily: 'MaterialIcons'), // close
                            size: 18,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: accentColors),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(NeoFadeRadii.md),
                    bottomRight: Radius.circular(NeoFadeRadii.md),
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

/// Type of snackbar that determines the accent color.
enum NeoSnackbarType {
  info,
  success,
  warning,
  error,
}
