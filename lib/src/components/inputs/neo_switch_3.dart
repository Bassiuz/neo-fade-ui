import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../theme/neo_fade_radii.dart';
import '../../utils/animation_utils.dart';

/// NeoSwitch3 - Pill switch with gradient track animation on toggle
///
/// A pill-shaped switch where the entire track animates to a vibrant
/// gradient when toggled on.
class NeoSwitch3 extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  const NeoSwitch3({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<NeoSwitch3> createState() => NeoSwitch3State();
}

class NeoSwitch3State extends State<NeoSwitch3>
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
  void didUpdateWidget(NeoSwitch3 oldWidget) {
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

    const trackWidth = 56.0;
    const trackHeight = 28.0;
    const thumbSize = 20.0;
    const thumbPadding = 4.0;

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
                      sigmaX: glass.blur * (1 - _animation.value * 0.5),
                      sigmaY: glass.blur * (1 - _animation.value * 0.5),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(NeoFadeRadii.full),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.lerp(
                              colors.surfaceVariant.withValues(alpha: glass.tintOpacity),
                              colors.primary,
                              _animation.value,
                            )!,
                            Color.lerp(
                              colors.surfaceVariant.withValues(alpha: glass.tintOpacity),
                              colors.secondary,
                              _animation.value,
                            )!,
                            Color.lerp(
                              colors.surfaceVariant.withValues(alpha: glass.tintOpacity),
                              colors.tertiary,
                              _animation.value,
                            )!,
                          ],
                        ),
                        border: Border.all(
                          color: Color.lerp(
                            colors.border.withValues(alpha: 0.3),
                            colors.primary.withValues(alpha: 0.5),
                            _animation.value,
                          )!,
                          width: 1,
                        ),
                        boxShadow: _animation.value > 0
                            ? [
                                BoxShadow(
                                  color: colors.primary
                                      .withValues(alpha: 0.2 * _animation.value),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Stack(
                        children: [
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
                                color: colors.surface,
                                border: Border.all(
                                  color: colors.border.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.onSurface.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
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
