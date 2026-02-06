import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Soft button with gradient shadow glow effect.
///
/// Use via `NeoButton.soft(...)` for convenient access.
class NeoButtonSoft extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  const NeoButtonSoft({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
  });

  @override
  State<NeoButtonSoft> createState() => NeoButtonSoftState();
}

class NeoButtonSoftState extends State<NeoButtonSoft>
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
    final glass = theme.glass;

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
          final glowIntensity = 1.0 - (_controller.value * 0.5);
          return AnimatedContainer(
            duration: NeoFadeAnimations.fast,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(NeoFadeRadii.md),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.3 * glowIntensity),
                  blurRadius: NeoFadeSpacing.lg * glowIntensity,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: colors.secondary.withValues(alpha: 0.2 * glowIntensity),
                  blurRadius: NeoFadeSpacing.xl * glowIntensity,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: child,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(NeoFadeRadii.md),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: NeoFadeSpacing.lg,
                vertical: NeoFadeSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: glass.tintOpacity + 0.1),
                borderRadius: BorderRadius.circular(NeoFadeRadii.md),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 18, color: colors.primary),
                    const SizedBox(width: NeoFadeSpacing.xs),
                  ],
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
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
