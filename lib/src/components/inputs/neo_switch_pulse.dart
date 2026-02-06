import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../theme/neo_fade_radii.dart';
import '../../utils/animation_utils.dart';

/// NeoSwitchPulse - Switch with gradient pulse effect when toggled
///
/// A switch that pulses with a gradient ring effect when toggled,
/// providing satisfying visual feedback.
class NeoSwitchPulse extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  const NeoSwitchPulse({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<NeoSwitchPulse> createState() => NeoSwitchPulseState();
}

class NeoSwitchPulseState extends State<NeoSwitchPulse>
    with TickerProviderStateMixin {
  late AnimationController _positionController;
  late AnimationController _pulseController;
  late Animation<double> _positionAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _pulseOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _positionController = AnimationController(
      duration: NeoFadeAnimations.normal,
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
    );
    _positionAnimation = CurvedAnimation(
      parent: _positionController,
      curve: NeoFadeAnimations.defaultCurve,
    );

    _pulseController = AnimationController(
      duration: NeoFadeAnimations.slow,
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeOut,
      ),
    );
    _pulseOpacityAnimation = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void didUpdateWidget(NeoSwitchPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _positionController.forward();
      } else {
        _positionController.reverse();
      }
      // Trigger pulse animation on any toggle
      _pulseController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _positionController.dispose();
    _pulseController.dispose();
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
    const maxPulseSize = 20.0;

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
            width: trackWidth + maxPulseSize,
            height: trackHeight + maxPulseSize,
            child: Center(
              child: SizedBox(
                width: trackWidth,
                height: trackHeight,
                child: AnimatedBuilder(
                  animation: Listenable.merge(
                      [_positionController, _pulseController]),
                  builder: (context, child) {
                    final thumbLeft = thumbPadding +
                        (_positionAnimation.value *
                            (trackWidth - thumbSize - thumbPadding * 2));
                    final thumbCenterX = thumbLeft + thumbSize / 2;
                    final thumbCenterY = trackHeight / 2;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Pulse rings
                        if (_pulseController.isAnimating ||
                            _pulseController.value > 0)
                          Positioned(
                            left: thumbCenterX - thumbSize / 2 -
                                (maxPulseSize * _pulseAnimation.value / 2),
                            top: thumbCenterY - thumbSize / 2 -
                                (maxPulseSize * _pulseAnimation.value / 2),
                            child: CustomPaint(
                              size: Size(
                                thumbSize + maxPulseSize * _pulseAnimation.value,
                                thumbSize + maxPulseSize * _pulseAnimation.value,
                              ),
                              painter: NeoSwitchPulsePainter(
                                progress: _pulseAnimation.value,
                                opacity: _pulseOpacityAnimation.value,
                                gradientColors: [
                                  colors.primary,
                                  colors.secondary,
                                  colors.tertiary,
                                ],
                              ),
                            ),
                          ),
                        // Track
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(NeoFadeRadii.full),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: glass.blur,
                              sigmaY: glass.blur,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.lerp(
                                  colors.surfaceVariant
                                      .withValues(alpha: glass.tintOpacity),
                                  colors.primary.withValues(alpha: 0.25),
                                  _positionAnimation.value,
                                ),
                                borderRadius:
                                    BorderRadius.circular(NeoFadeRadii.full),
                                border: Border.all(
                                  color: colors.border.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Gradient accent line at bottom
                                  Positioned(
                                    left: 4,
                                    right: 4,
                                    bottom: 2,
                                    child: Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(1),
                                        gradient: LinearGradient(
                                          colors: [
                                            colors.primary.withValues(
                                                alpha: _positionAnimation.value),
                                            colors.secondary.withValues(
                                                alpha: _positionAnimation.value),
                                            colors.tertiary.withValues(
                                                alpha: _positionAnimation.value),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Thumb
                                  Positioned(
                                    left: thumbLeft,
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
                                              _positionAnimation.value * 0.8,
                                            )!,
                                            Color.lerp(
                                              colors.surface,
                                              colors.secondary,
                                              _positionAnimation.value * 0.8,
                                            )!,
                                          ],
                                        ),
                                        border: Border.all(
                                          color: Color.lerp(
                                            colors.border.withValues(alpha: 0.3),
                                            colors.primary
                                                .withValues(alpha: 0.6),
                                            _positionAnimation.value,
                                          )!,
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: colors.onSurface
                                                .withValues(alpha: 0.15),
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
                        ),
                      ],
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

class NeoSwitchPulsePainter extends CustomPainter {
  final double progress;
  final double opacity;
  final List<Color> gradientColors;

  NeoSwitchPulsePainter({
    required this.progress,
    required this.opacity,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * (1 - progress)
      ..shader = SweepGradient(
        colors: [
          gradientColors[0].withValues(alpha: opacity),
          gradientColors[1].withValues(alpha: opacity),
          gradientColors[2].withValues(alpha: opacity),
          gradientColors[0].withValues(alpha: opacity),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(NeoSwitchPulsePainter oldDelegate) {
    return progress != oldDelegate.progress ||
        opacity != oldDelegate.opacity ||
        gradientColors != oldDelegate.gradientColors;
  }
}
