import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';

/// A wrapper widget that adds a pulsing gradient glow effect around its child.
///
/// Use this to draw attention to any widget without modifying the widget itself.
/// The glow uses colors from the theme (primary, secondary, tertiary) to create
/// a smooth pulsing effect.
class NeoPulsingGlow extends StatefulWidget {
  /// The widget to wrap with the pulsing glow effect.
  final Widget child;

  /// Duration of the pulse cycle.
  ///
  /// Defaults to 2 seconds.
  final Duration pulseDuration;

  /// Maximum blur radius of the glow.
  ///
  /// Defaults to [NeoFadeSpacing.lg] (16.0).
  final double maxGlowRadius;

  /// Opacity of the glow effect.
  ///
  /// Defaults to 0.4.
  final double glowOpacity;

  /// Border radius of the glow.
  ///
  /// Defaults to [NeoFadeRadii.md] (12.0).
  final BorderRadius borderRadius;

  /// Whether the glow effect is active.
  ///
  /// When false, the child is rendered without any glow effect.
  /// Defaults to true.
  final bool enabled;

  const NeoPulsingGlow({
    super.key,
    required this.child,
    this.pulseDuration = const Duration(seconds: 2),
    this.maxGlowRadius = NeoFadeSpacing.lg,
    this.glowOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(NeoFadeRadii.md)),
    this.enabled = true,
  });

  @override
  State<NeoPulsingGlow> createState() => NeoPulsingGlowState();
}

class NeoPulsingGlowState extends State<NeoPulsingGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.enabled) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(NeoPulsingGlow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.pulseDuration != oldWidget.pulseDuration) {
      _controller.duration = widget.pulseDuration;
    }

    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 0.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final glowRadius = widget.maxGlowRadius * _animation.value;
        final opacity = widget.glowOpacity * _animation.value;

        return Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: opacity),
                blurRadius: glowRadius,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: colors.secondary.withValues(alpha: opacity * 0.7),
                blurRadius: glowRadius * 1.2,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: colors.tertiary.withValues(alpha: opacity * 0.5),
                blurRadius: glowRadius * 1.5,
                spreadRadius: 0,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
