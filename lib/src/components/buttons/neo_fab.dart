import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Floating Action Button with gradient background and glow effect.
///
/// A prominent button for primary actions, featuring the Neo Fade gradient
/// style with a soft glow and press animation.
class NeoFAB extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool mini;
  final bool extended;
  final String? label;

  const NeoFAB({
    super.key,
    required this.icon,
    this.onPressed,
    this.mini = false,
    this.extended = false,
    this.label,
  });

  @override
  State<NeoFAB> createState() => NeoFABState();
}

class NeoFABState extends State<NeoFAB> with SingleTickerProviderStateMixin {
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
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final isEnabled = widget.onPressed != null;

    final size = widget.mini ? 40.0 : 56.0;
    final iconSize = widget.mini ? 20.0 : 24.0;

    final gradientColors = [colors.primary, colors.secondary];

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
            final scale = 1.0 - (_controller.value * 0.05);
            final hoverScale = _isHovered && isEnabled ? NeoFadeAnimations.hoverScale : 1.0;

            return Transform.scale(
              scale: scale * hoverScale,
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: NeoFadeAnimations.fast,
            height: size,
            padding: widget.extended && widget.label != null
                ? const EdgeInsets.symmetric(horizontal: NeoFadeSpacing.lg)
                : null,
            width: widget.extended && widget.label != null ? null : size,
            decoration: BoxDecoration(
              gradient: isEnabled
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    )
                  : null,
              color: isEnabled ? null : colors.disabled,
              borderRadius: BorderRadius.circular(
                widget.extended ? NeoFadeRadii.lg : NeoFadeRadii.full,
              ),
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: colors.primary.withValues(
                          alpha: _isHovered ? 0.5 : 0.4,
                        ),
                        blurRadius: _isHovered ? NeoFadeSpacing.lg : NeoFadeSpacing.md,
                        offset: const Offset(0, 4),
                        spreadRadius: _isHovered ? 2 : 0,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: iconSize,
                  color: isEnabled ? colors.onPrimary : colors.disabledText,
                ),
                if (widget.extended && widget.label != null) ...[
                  const SizedBox(width: NeoFadeSpacing.sm),
                  Text(
                    widget.label!,
                    style: theme.typography.labelLarge.copyWith(
                      color: isEnabled ? colors.onPrimary : colors.disabledText,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
