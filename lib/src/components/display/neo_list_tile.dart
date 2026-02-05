import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// List item with glass background on hover/selection.
///
/// A list tile component with the Neo Fade glass effect that activates
/// on hover or selection, with optional leading/trailing widgets.
class NeoListTile extends StatefulWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;

  const NeoListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected = false,
    this.enabled = true,
    this.contentPadding,
  });

  @override
  State<NeoListTile> createState() => NeoListTileState();
}

class NeoListTileState extends State<NeoListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.fast,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _showGlassEffect => _isHovered || _isPressed || widget.selected;

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;
    final isEnabled = widget.enabled && widget.onTap != null;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onTap?.call();
            }
          : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      child: MouseRegion(
        cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: NeoFadeAnimations.fast,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(NeoFadeRadii.sm),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(NeoFadeRadii.sm),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _showGlassEffect ? glass.blur : 0,
                sigmaY: _showGlassEffect ? glass.blur : 0,
              ),
              child: AnimatedContainer(
                duration: NeoFadeAnimations.fast,
                padding: widget.contentPadding ??
                    const EdgeInsets.symmetric(
                      horizontal: NeoFadeSpacing.lg,
                      vertical: NeoFadeSpacing.md,
                    ),
                decoration: BoxDecoration(
                  gradient: widget.selected
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colors.primary.withValues(alpha: 0.15),
                            colors.secondary.withValues(alpha: 0.08),
                          ],
                        )
                      : null,
                  color: _showGlassEffect && !widget.selected
                      ? colors.surface.withValues(
                          alpha: _isPressed
                              ? glass.tintOpacity + 0.1
                              : glass.tintOpacity,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(NeoFadeRadii.sm),
                  border: widget.selected
                      ? Border.all(
                          color: colors.primary.withValues(alpha: 0.3),
                          width: 1,
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    if (widget.leading != null) ...[
                      widget.leading!,
                      const SizedBox(width: NeoFadeSpacing.md),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: theme.typography.bodyLarge.copyWith(
                              color: widget.enabled
                                  ? (widget.selected
                                      ? colors.primary
                                      : colors.onSurface)
                                  : colors.disabledText,
                              fontWeight: widget.selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          if (widget.subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              widget.subtitle!,
                              style: theme.typography.bodySmall.copyWith(
                                color: widget.enabled
                                    ? colors.onSurfaceVariant
                                    : colors.disabledText,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.trailing != null) ...[
                      const SizedBox(width: NeoFadeSpacing.md),
                      widget.trailing!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
