import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_colors.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../utils/animation_utils.dart';

/// Animated CTA button for navigation with floating idle animation and press effects.
///
/// Features:
/// - Rounded square shape (borderRadius: 16)
/// - Gradient fill from primary to secondary color
/// - Glow effect with boxShadow
/// - Idle: Floating animation (subtle up/down movement, 2s cycle)
/// - Press: Scale down to 0.9 + slight rotation
class NeoNavCTAButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final NeoFadeColors colors;
  final double size;
  final double borderRadius;
  final bool animated;

  const NeoNavCTAButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.colors,
    this.size = 56,
    this.borderRadius = NeoFadeRadii.lg,
    this.animated = true,
  });

  @override
  State<NeoNavCTAButton> createState() => NeoNavCTAButtonState();
}

class NeoNavCTAButtonState extends State<NeoNavCTAButton>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _pressController;
  late Animation<double> _floatAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Floating idle animation (2 second cycle)
    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    if (widget.animated) {
      _floatController.repeat(reverse: true);
    }

    _floatAnimation = Tween<double>(
      begin: 0,
      end: 4,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    // Press animation
    _pressController = AnimationController(
      duration: NeoFadeAnimations.fast,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: math.pi / 36, // ~5 degrees
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _pressController.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: Listenable.merge([_floatAnimation, _pressController]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, widget.animated ? -_floatAnimation.value : 0),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: child,
              ),
            ),
          );
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [widget.colors.primary, widget.colors.secondary],
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: widget.colors.primary.withValues(alpha: 0.4),
                blurRadius: NeoFadeSpacing.lg,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: widget.colors.secondary.withValues(alpha: 0.2),
                blurRadius: NeoFadeSpacing.xl,
                spreadRadius: 0,
                offset: const Offset(0, 8),
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
