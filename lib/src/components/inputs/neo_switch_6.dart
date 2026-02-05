import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../theme/neo_fade_radii.dart';
import '../../utils/animation_utils.dart';

/// NeoSwitch6 - Switch with gradient expanding from thumb on toggle
///
/// A switch where the gradient appears to expand outward from the thumb
/// position when toggled on, creating a ripple-like effect.
class NeoSwitch6 extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  const NeoSwitch6({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<NeoSwitch6> createState() => NeoSwitch6State();
}

class NeoSwitch6State extends State<NeoSwitch6>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _expandAnimation;

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
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(NeoSwitch6 oldWidget) {
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
                final thumbLeft = thumbPadding +
                    (_positionAnimation.value *
                        (trackWidth - thumbSize - thumbPadding * 2));
                final thumbCenter = thumbLeft + thumbSize / 2;

                return ClipRRect(
                  borderRadius: BorderRadius.circular(NeoFadeRadii.full),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: glass.blur,
                      sigmaY: glass.blur,
                    ),
                    child: CustomPaint(
                      painter: NeoSwitch6TrackPainter(
                        expandProgress: _expandAnimation.value,
                        thumbCenterX: thumbCenter,
                        trackWidth: trackWidth,
                        trackHeight: trackHeight,
                        offColor: colors.surfaceVariant
                            .withValues(alpha: glass.tintOpacity),
                        gradientColors: [
                          colors.primary,
                          colors.secondary,
                          colors.tertiary,
                        ],
                        borderColor: colors.border.withValues(alpha: 0.3),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: thumbLeft,
                            top: thumbPadding,
                            child: Container(
                              width: thumbSize,
                              height: thumbSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    colors.surface,
                                    colors.surface.withValues(alpha: 0.95),
                                  ],
                                ),
                                border: Border.all(
                                  color: Color.lerp(
                                    colors.border.withValues(alpha: 0.3),
                                    colors.primary.withValues(alpha: 0.5),
                                    _expandAnimation.value,
                                  )!,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.lerp(
                                      colors.onSurface.withValues(alpha: 0.15),
                                      colors.primary.withValues(alpha: 0.3),
                                      _expandAnimation.value,
                                    )!,
                                    blurRadius: 6,
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

class NeoSwitch6TrackPainter extends CustomPainter {
  final double expandProgress;
  final double thumbCenterX;
  final double trackWidth;
  final double trackHeight;
  final Color offColor;
  final List<Color> gradientColors;
  final Color borderColor;

  NeoSwitch6TrackPainter({
    required this.expandProgress,
    required this.thumbCenterX,
    required this.trackWidth,
    required this.trackHeight,
    required this.offColor,
    required this.gradientColors,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(size.height / 2),
    );

    // Draw off state background
    final offPaint = Paint()..color = offColor;
    canvas.drawRRect(rrect, offPaint);

    // Draw expanding gradient from thumb center
    if (expandProgress > 0) {
      canvas.save();
      canvas.clipRRect(rrect);

      final expandRadius = trackWidth * expandProgress;
      final gradientCenter = Offset(thumbCenterX, size.height / 2);

      final gradientPaint = Paint()
        ..shader = RadialGradient(
          center: Alignment(
            (thumbCenterX - size.width / 2) / (size.width / 2),
            0,
          ),
          radius: 1.5,
          colors: [
            gradientColors[0],
            gradientColors[1],
            gradientColors[2],
            gradientColors[2].withValues(alpha: 0),
          ],
          stops: const [0.0, 0.4, 0.7, 1.0],
        ).createShader(Rect.fromCircle(
          center: gradientCenter,
          radius: expandRadius,
        ));

      canvas.drawCircle(gradientCenter, expandRadius, gradientPaint);
      canvas.restore();
    }

    // Draw border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(NeoSwitch6TrackPainter oldDelegate) {
    return expandProgress != oldDelegate.expandProgress ||
        thumbCenterX != oldDelegate.thumbCenterX ||
        offColor != oldDelegate.offColor ||
        gradientColors != oldDelegate.gradientColors ||
        borderColor != oldDelegate.borderColor;
  }
}
