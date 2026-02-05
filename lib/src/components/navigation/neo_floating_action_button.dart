import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_colors.dart';
import '../../theme/neo_fade_radii.dart';
import '../../utils/animation_utils.dart';

/// A small floating action button with press animation.
class NeoFloatingActionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final NeoFadeColors colors;
  final double iconSize;

  const NeoFloatingActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    required this.colors,
    this.iconSize = 22,
  });

  @override
  State<NeoFloatingActionButton> createState() =>
      NeoFloatingActionButtonState();
}

class NeoFloatingActionButtonState extends State<NeoFloatingActionButton>
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
        widget.onPressed?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.1),
            child: child,
          );
        },
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: widget.colors.surface.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(NeoFadeRadii.md),
          ),
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: widget.colors.onSurface,
          ),
        ),
      ),
    );
  }
}
