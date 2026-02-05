import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';

/// Circular progress indicator with gradient stroke.
class NeoCircularProgressIndicator extends StatefulWidget {
  final double? value;
  final double size;
  final double strokeWidth;
  final bool showGlow;

  const NeoCircularProgressIndicator({
    super.key,
    this.value,
    this.size = 40,
    this.strokeWidth = 4,
    this.showGlow = true,
  });

  @override
  State<NeoCircularProgressIndicator> createState() =>
      NeoCircularProgressIndicatorState();
}

class NeoCircularProgressIndicatorState
    extends State<NeoCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool get _isIndeterminate => widget.value == null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    if (_isIndeterminate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(NeoCircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isIndeterminate != (oldWidget.value == null)) {
      if (_isIndeterminate) {
        _controller.repeat();
      } else {
        _controller.stop();
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
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: NeoCircularProgressPainter(
              value: widget.value,
              animationValue: _controller.value,
              gradientColors: [
                colors.primary,
                colors.secondary,
                colors.tertiary,
              ],
              backgroundColor: colors.surfaceVariant.withValues(alpha: 0.5),
              strokeWidth: widget.strokeWidth,
              glowColor: widget.showGlow
                  ? colors.primary.withValues(alpha: 0.4)
                  : null,
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter for circular progress indicator.
class NeoCircularProgressPainter extends CustomPainter {
  final double? value;
  final double animationValue;
  final List<Color> gradientColors;
  final Color backgroundColor;
  final double strokeWidth;
  final Color? glowColor;

  NeoCircularProgressPainter({
    this.value,
    required this.animationValue,
    required this.gradientColors,
    required this.backgroundColor,
    required this.strokeWidth,
    this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Draw background track
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: math.pi * 2,
        colors: [...gradientColors, gradientColors.first],
        transform: GradientRotation(-math.pi / 2 + animationValue * math.pi * 2),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (glowColor != null) {
      final glowPaint = Paint()
        ..color = glowColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 4
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      if (value != null) {
        final sweepAngle = math.pi * 2 * value!.clamp(0.0, 1.0);
        canvas.drawArc(
          rect,
          -math.pi / 2,
          sweepAngle,
          false,
          glowPaint,
        );
      } else {
        final startAngle = -math.pi / 2 + animationValue * math.pi * 2;
        final sweepAngle = math.pi * 0.75;
        canvas.drawArc(
          rect,
          startAngle,
          sweepAngle,
          false,
          glowPaint,
        );
      }
    }

    if (value != null) {
      final sweepAngle = math.pi * 2 * value!.clamp(0.0, 1.0);
      canvas.drawArc(
        rect,
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    } else {
      final startAngle = -math.pi / 2 + animationValue * math.pi * 2;
      final sweepAngle = math.pi * 0.75;
      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(NeoCircularProgressPainter oldDelegate) {
    return value != oldDelegate.value ||
        animationValue != oldDelegate.animationValue ||
        gradientColors != oldDelegate.gradientColors ||
        backgroundColor != oldDelegate.backgroundColor ||
        strokeWidth != oldDelegate.strokeWidth ||
        glowColor != oldDelegate.glowColor;
  }
}
