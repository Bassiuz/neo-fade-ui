import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../theme/neo_fade_radii.dart';
import '../../utils/animation_utils.dart';

/// NeoSwitchMinimal - Minimal switch with gradient line indicator
///
/// A minimalist design featuring a thin gradient line that appears
/// beneath the track when toggled on.
class NeoSwitchMinimal extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  const NeoSwitchMinimal({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<NeoSwitchMinimal> createState() => NeoSwitchMinimalState();
}

class NeoSwitchMinimalState extends State<NeoSwitchMinimal>
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
  void didUpdateWidget(NeoSwitchMinimal oldWidget) {
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

    const trackWidth = 48.0;
    const trackHeight = 24.0;
    const thumbSize = 18.0;
    const thumbPadding = 3.0;
    const indicatorHeight = 3.0;

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
            height: trackHeight + indicatorHeight + 4,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Track
                    SizedBox(
                      width: trackWidth,
                      height: trackHeight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(NeoFadeRadii.full),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: glass.blur * 0.5,
                            sigmaY: glass.blur * 0.5,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.surfaceVariant
                                  .withValues(alpha: glass.tintOpacity * 0.6),
                              borderRadius:
                                  BorderRadius.circular(NeoFadeRadii.full),
                              border: Border.all(
                                color: colors.border.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: thumbPadding +
                                      (_animation.value *
                                          (trackWidth -
                                              thumbSize -
                                              thumbPadding * 2)),
                                  top: thumbPadding,
                                  child: Container(
                                    width: thumbSize,
                                    height: thumbSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.lerp(
                                        colors.onSurfaceVariant,
                                        colors.primary,
                                        _animation.value,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: colors.onSurface
                                              .withValues(alpha: 0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Gradient line indicator
                    Container(
                      width: trackWidth,
                      height: indicatorHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(indicatorHeight / 2),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            colors.primary.withValues(alpha: _animation.value),
                            colors.secondary.withValues(alpha: _animation.value),
                            colors.tertiary.withValues(alpha: _animation.value),
                          ],
                        ),
                        boxShadow: _animation.value > 0
                            ? [
                                BoxShadow(
                                  color: colors.primary
                                      .withValues(alpha: 0.3 * _animation.value),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
