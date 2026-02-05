import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../foundation/gradient_border.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Glass chip with gradient border on selection.
///
/// A compact element that represents an input, attribute, or action,
/// featuring the Neo Fade glass effect with gradient border when selected.
class NeoChip extends StatefulWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool enabled;

  const NeoChip({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
    this.onDelete,
    this.enabled = true,
  });

  @override
  State<NeoChip> createState() => NeoChipState();
}

class NeoChipState extends State<NeoChip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

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

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;
    final isEnabled = widget.enabled && (widget.onTap != null || widget.onDelete != null);

    return GestureDetector(
      onTapDown: isEnabled ? _handleTapDown : null,
      onTapUp: isEnabled ? _handleTapUp : null,
      onTapCancel: isEnabled ? _handleTapCancel : null,
      child: MouseRegion(
        cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 - (_controller.value * 0.03),
              child: child,
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(NeoFadeRadii.full),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: glass.blur,
                sigmaY: glass.blur,
              ),
              child: CustomPaint(
                painter: GradientBorderPainter(
                  colors: widget.selected
                      ? [colors.primary, colors.secondary, colors.tertiary]
                      : [colors.border.withValues(alpha: _isHovered ? 0.6 : 0.3)],
                  borderWidth: widget.selected ? 2 : 1,
                  borderRadius: BorderRadius.circular(NeoFadeRadii.full),
                  bottomOnly: false,
                ),
                child: AnimatedContainer(
                  duration: NeoFadeAnimations.fast,
                  padding: const EdgeInsets.symmetric(
                    horizontal: NeoFadeSpacing.md,
                    vertical: NeoFadeSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    gradient: widget.selected
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colors.primary.withValues(alpha: 0.15),
                              colors.secondary.withValues(alpha: 0.1),
                            ],
                          )
                        : null,
                    color: widget.selected
                        ? null
                        : colors.surface.withValues(alpha: glass.tintOpacity),
                    borderRadius: BorderRadius.circular(NeoFadeRadii.full),
                    boxShadow: widget.selected
                        ? [
                            BoxShadow(
                              color: colors.primary.withValues(alpha: 0.2),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          size: 16,
                          color: widget.enabled
                              ? (widget.selected
                                  ? colors.primary
                                  : colors.onSurfaceVariant)
                              : colors.disabledText,
                        ),
                        const SizedBox(width: NeoFadeSpacing.xs),
                      ],
                      Text(
                        widget.label,
                        style: theme.typography.labelMedium.copyWith(
                          color: widget.enabled
                              ? (widget.selected
                                  ? colors.primary
                                  : colors.onSurface)
                              : colors.disabledText,
                        ),
                      ),
                      if (widget.onDelete != null) ...[
                        const SizedBox(width: NeoFadeSpacing.xs),
                        GestureDetector(
                          onTap: widget.enabled ? widget.onDelete : null,
                          child: Icon(
                            const IconData(0xe5cd,
                                fontFamily: 'MaterialIcons'), // close
                            size: 16,
                            color: widget.enabled
                                ? colors.onSurfaceVariant
                                : colors.disabledText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
