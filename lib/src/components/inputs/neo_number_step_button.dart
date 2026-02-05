import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_colors.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../utils/animation_utils.dart';

/// Step button for number selectors with press animation.
class NeoNumberStepButton extends StatefulWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;
  final NeoFadeColors colors;
  final bool isPrimary;

  const NeoNumberStepButton({
    super.key,
    required this.icon,
    required this.enabled,
    required this.onPressed,
    required this.colors,
    this.isPrimary = false,
  });

  @override
  State<NeoNumberStepButton> createState() => NeoNumberStepButtonState();
}

class NeoNumberStepButtonState extends State<NeoNumberStepButton>
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
              gradient: widget.isPrimary && widget.enabled
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [widget.colors.primary, widget.colors.secondary],
                    )
                  : null,
              color: widget.isPrimary
                  ? null
                  : widget.colors.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(NeoFadeRadii.sm),
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: widget.isPrimary && widget.enabled
                  ? widget.colors.onPrimary
                  : widget.colors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
