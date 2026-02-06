import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_colors.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../utils/animation_utils.dart';

/// Floating center CTA button that appears above the navigation bar.
class NeoBottomNavCtaFloatingButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final NeoFadeColors colors;

  const NeoBottomNavCtaFloatingButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.colors,
  });

  @override
  State<NeoBottomNavCtaFloatingButton> createState() =>
      NeoBottomNavCtaFloatingButtonState();
}

class NeoBottomNavCtaFloatingButtonState
    extends State<NeoBottomNavCtaFloatingButton>
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
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.05),
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(NeoFadeSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.colors.primary,
                widget.colors.secondary,
                widget.colors.tertiary,
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.colors.primary.withValues(alpha: 0.5),
                blurRadius: NeoFadeSpacing.lg,
                spreadRadius: NeoFadeSpacing.xxs,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: widget.colors.secondary.withValues(alpha: 0.3),
                blurRadius: NeoFadeSpacing.xl,
                spreadRadius: 0,
              ),
            ],
            border: Border.all(
              color: const Color(0xFFFFFFFF).withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Icon(
            widget.icon,
            size: 32,
            color: widget.colors.onPrimary,
          ),
        ),
      ),
    );
  }
}
