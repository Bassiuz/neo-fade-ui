import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Text-only button with gradient underline on hover/press.
///
/// A minimal button that displays text with a subtle gradient underline
/// that appears on interaction, following the Neo Fade aesthetic.
class NeoTextButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool iconAfter;

  const NeoTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.iconAfter = false,
  });

  @override
  State<NeoTextButton> createState() => NeoTextButtonState();
}

class NeoTextButtonState extends State<NeoTextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.normal,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final isEnabled = widget.onPressed != null;

    final showUnderline = (_isHovered || _isPressed) && isEnabled;

    final textColor = isEnabled
        ? (_isPressed ? colors.primaryPressed : colors.primary)
        : colors.disabledText;

    final iconWidget = widget.icon != null
        ? Padding(
            padding: EdgeInsets.only(
              left: widget.iconAfter ? NeoFadeSpacing.xs : 0,
              right: widget.iconAfter ? 0 : NeoFadeSpacing.xs,
            ),
            child: Icon(
              widget.icon,
              size: 16,
              color: textColor,
            ),
          )
        : null;

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
              scale: 1.0 - (_controller.value * 0.02),
              child: child,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NeoFadeSpacing.sm,
              vertical: NeoFadeSpacing.xs,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!widget.iconAfter && iconWidget != null) iconWidget,
                    Text(
                      widget.label,
                      style: theme.typography.labelLarge.copyWith(
                        color: textColor,
                      ),
                    ),
                    if (widget.iconAfter && iconWidget != null) iconWidget,
                  ],
                ),
                const SizedBox(height: 2),
                AnimatedContainer(
                  duration: NeoFadeAnimations.fast,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: showUnderline
                        ? LinearGradient(
                            colors: [
                              colors.primary,
                              colors.secondary,
                              colors.tertiary,
                            ],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return AnimatedContainer(
                        duration: NeoFadeAnimations.fast,
                        width: showUnderline ? null : 0,
                        constraints: showUnderline
                            ? BoxConstraints(minWidth: constraints.maxWidth)
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
