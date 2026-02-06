import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../theme/neo_fade_radii.dart';
import '../../utils/animation_utils.dart';

/// NeoSwitchBouncy - Glass switch with bouncy thumb animation
///
/// A playful switch with a glass track where the thumb bounces
/// elastically when toggled.
class NeoSwitchBouncy extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  const NeoSwitchBouncy({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<NeoSwitchBouncy> createState() => NeoSwitchBouncyState();
}

class NeoSwitchBouncyState extends State<NeoSwitchBouncy>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.slow,
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
    );
    _positionAnimation = CurvedAnimation(
      parent: _controller,
      curve: NeoFadeAnimations.bounceCurve,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.85),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 1.15),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(NeoSwitchBouncy oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward(from: 0);
      } else {
        _controller.reverse(from: 1);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.enabled && widget.onChanged != null) {
      widget.onChanged!(!widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    const trackWidth = 54.0;
    const trackHeight = 30.0;
    const thumbSize = 24.0;
    const thumbPadding = 3.0;

    final opacity = widget.enabled ? 1.0 : NeoFadeAnimations.disabledOpacity;

    return GestureDetector(
      onTap: _handleTap,
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: AnimatedOpacity(
          duration: NeoFadeAnimations.fast,
          opacity: opacity,
          child: SizedBox(
            width: trackWidth,
            height: trackHeight,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(NeoFadeRadii.full),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: glass.blur,
                      sigmaY: glass.blur,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.lerp(
                              colors.surfaceVariant
                                  .withValues(alpha: glass.tintOpacity),
                              colors.primary.withValues(alpha: 0.3),
                              _positionAnimation.value,
                            )!,
                            Color.lerp(
                              colors.surfaceVariant
                                  .withValues(alpha: glass.tintOpacity * 0.8),
                              colors.secondary.withValues(alpha: 0.3),
                              _positionAnimation.value,
                            )!,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(NeoFadeRadii.full),
                        border: Border.all(
                          color: Color.lerp(
                            colors.border.withValues(alpha: 0.3),
                            colors.primary.withValues(alpha: 0.5),
                            _positionAnimation.value,
                          )!,
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: thumbPadding +
                                (_positionAnimation.value *
                                    (trackWidth - thumbSize - thumbPadding * 2)),
                            top: thumbPadding,
                            child: Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Container(
                                width: thumbSize,
                                height: thumbSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      colors.primary,
                                      colors.secondary,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          colors.primary.withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Container(
                                    width: thumbSize * 0.5,
                                    height: thumbSize * 0.5,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colors.surface
                                          .withValues(alpha: 0.9),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
