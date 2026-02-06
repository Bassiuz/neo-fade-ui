import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Gradient-filled button with glass effect and shadow.
///
/// Use via `NeoButton.filled(...)` for convenient access.
class NeoButtonFilled extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final TextStyle? textStyle;
  final double? iconSize;

  const NeoButtonFilled({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.padding,
    this.borderRadius,
    this.textStyle,
    this.iconSize,
  });

  @override
  State<NeoButtonFilled> createState() => NeoButtonFilledState();
}

class NeoButtonFilledState extends State<NeoButtonFilled>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;

    final effectivePadding = widget.padding ??
        const EdgeInsets.symmetric(
          horizontal: NeoFadeSpacing.lg,
          vertical: NeoFadeSpacing.sm,
        );
    final effectiveBorderRadius = widget.borderRadius ?? NeoFadeRadii.md;
    final effectiveIconSize = widget.iconSize ?? 18.0;
    final effectiveTextStyle = widget.textStyle ??
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colors.onPrimary,
        );

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.03),
            child: child,
          );
        },
        child: Container(
          padding: effectivePadding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.primary, colors.secondary],
            ),
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.4),
                blurRadius: NeoFadeSpacing.md,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: effectiveIconSize, color: colors.onPrimary),
                const SizedBox(width: NeoFadeSpacing.xs),
              ],
              Text(
                widget.label,
                style: effectiveTextStyle.copyWith(
                  color: effectiveTextStyle.color ?? colors.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
