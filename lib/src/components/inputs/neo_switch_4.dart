import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../theme/neo_fade_radii.dart';
import '../../utils/animation_utils.dart';

/// NeoSwitch4 - Glass switch with glowing gradient thumb
///
/// Features a subtle glass track with a thumb that glows with
/// a vibrant gradient when the switch is on.
class NeoSwitch4 extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  const NeoSwitch4({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<NeoSwitch4> createState() => NeoSwitch4State();
}

class NeoSwitch4State extends State<NeoSwitch4>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.normal,
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: NeoFadeAnimations.defaultCurve,
    );
  }

  @override
  void didUpdateWidget(NeoSwitch4 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
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

    const trackWidth = 52.0;
    const trackHeight = 28.0;
    const thumbSize = 22.0;
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
              animation: _animation,
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
                        color: colors.surfaceVariant
                            .withValues(alpha: glass.tintOpacity),
                        borderRadius: BorderRadius.circular(NeoFadeRadii.full),
                        border: Border.all(
                          color: colors.border.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Glow effect behind thumb
                          Positioned(
                            left: thumbPadding +
                                (_animation.value *
                                    (trackWidth - thumbSize - thumbPadding * 2)) -
                                8,
                            top: thumbPadding - 8,
                            child: Container(
                              width: thumbSize + 16,
                              height: thumbSize + 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    colors.primary
                                        .withValues(alpha: 0.5 * _animation.value),
                                    colors.secondary
                                        .withValues(alpha: 0.3 * _animation.value),
                                    colors.tertiary.withValues(alpha: 0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Thumb
                          Positioned(
                            left: thumbPadding +
                                (_animation.value *
                                    (trackWidth - thumbSize - thumbPadding * 2)),
                            top: thumbPadding,
                            child: Container(
                              width: thumbSize,
                              height: thumbSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.lerp(
                                      colors.surface,
                                      colors.primary,
                                      _animation.value,
                                    )!,
                                    Color.lerp(
                                      colors.surface,
                                      colors.secondary,
                                      _animation.value,
                                    )!,
                                  ],
                                ),
                                border: Border.all(
                                  color: Color.lerp(
                                    colors.border.withValues(alpha: 0.3),
                                    colors.primary.withValues(alpha: 0.6),
                                    _animation.value,
                                  )!,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.lerp(
                                      colors.onSurface.withValues(alpha: 0.1),
                                      colors.primary.withValues(alpha: 0.4),
                                      _animation.value,
                                    )!,
                                    blurRadius: 8 + (_animation.value * 4),
                                    spreadRadius: _animation.value * 2,
                                  ),
                                ],
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
