import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../theme/neo_fade_radii.dart';
import '../../utils/animation_utils.dart';

/// NeoSwitch2 - iOS-style glass switch with gradient fill when on
///
/// An iOS-inspired switch with a frosted glass appearance that fills
/// with a vibrant gradient when toggled on.
class NeoSwitch2 extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  const NeoSwitch2({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<NeoSwitch2> createState() => NeoSwitch2State();
}

class NeoSwitch2State extends State<NeoSwitch2>
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
  void didUpdateWidget(NeoSwitch2 oldWidget) {
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
    const trackHeight = 32.0;
    const thumbSize = 26.0;
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
                    child: CustomPaint(
                      painter: NeoSwitch2TrackPainter(
                        progress: _animation.value,
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
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.onSurface.withValues(alpha: 0.15),
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

class NeoSwitch2TrackPainter extends CustomPainter {
  final double progress;
  final Color offColor;
  final List<Color> gradientColors;
  final Color borderColor;

  NeoSwitch2TrackPainter({
    required this.progress,
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

    // Draw gradient fill based on progress
    if (progress > 0) {
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: gradientColors,
        ).createShader(rect);

      canvas.save();
      canvas.clipRRect(rrect);
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width * progress, size.height),
        gradientPaint,
      );
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
  bool shouldRepaint(NeoSwitch2TrackPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        offColor != oldDelegate.offColor ||
        gradientColors != oldDelegate.gradientColors ||
        borderColor != oldDelegate.borderColor;
  }
}
