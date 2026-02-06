import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_colors.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../utils/animation_utils.dart';

/// Center CTA button that appears inline within the navigation bar.
class NeoBottomNavCtaCenterButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final NeoFadeColors colors;

  const NeoBottomNavCtaCenterButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.colors,
  });

  @override
  State<NeoBottomNavCtaCenterButton> createState() =>
      NeoBottomNavCtaCenterButtonState();
}

class NeoBottomNavCtaCenterButtonState
    extends State<NeoBottomNavCtaCenterButton>
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
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.05),
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(NeoFadeSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [widget.colors.primary, widget.colors.secondary],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.colors.primary.withValues(alpha: 0.4),
                blurRadius: NeoFadeSpacing.md,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            size: 28,
            color: widget.colors.onPrimary,
          ),
        ),
      ),
    );
  }
}
