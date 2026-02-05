import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../theme/neo_fade_radii.dart';
import '../../utils/animation_utils.dart';

/// NeoSwitch1 - Glass track with gradient thumb, slides smoothly
///
/// Features a frosted glass track with a vibrant gradient thumb
/// that slides smoothly between on/off positions.
class NeoSwitch1 extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  const NeoSwitch1({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<NeoSwitch1> createState() => NeoSwitch1State();
}

class NeoSwitch1State extends State<NeoSwitch1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.normal,
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
    );
    _positionAnimation = CurvedAnimation(
      parent: _controller,
      curve: NeoFadeAnimations.defaultCurve,
    );
  }

  @override
  void didUpdateWidget(NeoSwitch1 oldWidget) {
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(NeoFadeRadii.full),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: glass.blur,
                  sigmaY: glass.blur,
                ),
                child: AnimatedBuilder(
                  animation: _positionAnimation,
                  builder: (context, child) {
                    final trackColor = Color.lerp(
                      colors.surfaceVariant.withValues(alpha: glass.tintOpacity),
                      colors.primary.withValues(alpha: 0.3),
                      _positionAnimation.value,
                    )!;

                    return Container(
                      decoration: BoxDecoration(
                        color: trackColor,
                        borderRadius: BorderRadius.circular(NeoFadeRadii.full),
                        border: Border.all(
                          color: colors.border.withValues(alpha: 0.3),
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
                                    colors.tertiary,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.primary.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
