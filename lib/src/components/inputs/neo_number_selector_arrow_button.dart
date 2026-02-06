import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_spacing.dart';
import '../../utils/animation_utils.dart';

/// Arrow button used in NeoNumberSelectorVertical.
class NeoNumberSelectorArrowButton extends StatefulWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;
  final dynamic colors;

  const NeoNumberSelectorArrowButton({
    super.key,
    required this.icon,
    required this.enabled,
    required this.onPressed,
    required this.colors,
  });

  @override
  State<NeoNumberSelectorArrowButton> createState() =>
      NeoNumberSelectorArrowButtonState();
}

class NeoNumberSelectorArrowButtonState
    extends State<NeoNumberSelectorArrowButton>
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
      onTapDown: widget.enabled ? (_) => _controller.forward() : null,
      onTapUp: widget.enabled
          ? (_) {
              _controller.reverse();
              widget.onPressed();
            }
          : null,
      onTapCancel: widget.enabled ? () => _controller.reverse() : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.15),
            child: child,
          );
        },
        child: AnimatedOpacity(
          duration: NeoFadeAnimations.fast,
          opacity: widget.enabled ? 1.0 : 0.3,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: NeoFadeSpacing.lg,
              vertical: NeoFadeSpacing.xs,
            ),
            child: Icon(
              widget.icon,
              size: 28,
              color: widget.enabled
                  ? widget.colors.primary
                  : widget.colors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
