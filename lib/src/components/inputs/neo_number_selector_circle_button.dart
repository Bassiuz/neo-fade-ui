import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_spacing.dart';
import '../../utils/animation_utils.dart';

/// Circle button used in NeoNumberSelectorCompact.
class NeoNumberSelectorCircleButton extends StatefulWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;
  final dynamic colors;
  final bool isGradient;

  const NeoNumberSelectorCircleButton({
    super.key,
    required this.icon,
    required this.enabled,
    required this.onPressed,
    required this.colors,
    this.isGradient = false,
  });

  @override
  State<NeoNumberSelectorCircleButton> createState() =>
      NeoNumberSelectorCircleButtonState();
}

class NeoNumberSelectorCircleButtonState
    extends State<NeoNumberSelectorCircleButton>
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
            scale: 1.0 - (_controller.value * 0.1),
            child: child,
          );
        },
        child: AnimatedOpacity(
          duration: NeoFadeAnimations.fast,
          opacity: widget.enabled ? 1.0 : 0.4,
          child: Container(
            padding: const EdgeInsets.all(NeoFadeSpacing.sm),
            decoration: BoxDecoration(
              gradient: widget.isGradient && widget.enabled
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [widget.colors.primary, widget.colors.secondary],
                    )
                  : null,
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: widget.isGradient && widget.enabled
                  ? widget.colors.onPrimary
                  : widget.colors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
