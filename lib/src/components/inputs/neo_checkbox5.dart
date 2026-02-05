import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Checkbox with animated gradient sweep on check.
///
/// A glass checkbox featuring a dramatic gradient sweep animation that
/// rotates through the checkbox when checked, leaving a vibrant fill.
class NeoCheckbox5 extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final double size;

  const NeoCheckbox5({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.size = 24.0,
  });

  @override
  State<NeoCheckbox5> createState() => NeoCheckbox5State();
}

class NeoCheckbox5State extends State<NeoCheckbox5>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sweepAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.slow,
      vsync: this,
    );

    _sweepAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
    );

    _checkAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(NeoCheckbox5 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
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
    widget.onChanged?.call(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;
    final isEnabled = widget.onChanged != null;

    final checkbox = GestureDetector(
      onTap: isEnabled ? _handleTap : null,
      child: MouseRegion(
        cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: glass.blur,
                  sigmaY: glass.blur,
                ),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: glass.tintOpacity),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: colors.border.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                  child: CustomPaint(
                    painter: NeoCheckbox5Painter(
                      sweepProgress: _sweepAnimation.value,
                      checkProgress: _checkAnimation.value,
                      gradientColors: [
                        colors.primary,
                        colors.secondary,
                        colors.tertiary,
                      ],
                      checkColor: colors.onPrimary,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    if (widget.label != null) {
      return GestureDetector(
        onTap: isEnabled ? _handleTap : null,
        child: MouseRegion(
          cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              checkbox,
              const SizedBox(width: 8),
              Text(
                widget.label!,
                style: theme.typography.bodyMedium.copyWith(
                  color: isEnabled ? colors.onSurface : colors.disabledText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return checkbox;
  }
}

class NeoCheckbox5Painter extends CustomPainter {
  final double sweepProgress;
  final double checkProgress;
  final List<Color> gradientColors;
  final Color checkColor;

  NeoCheckbox5Painter({
    required this.sweepProgress,
    required this.checkProgress,
    required this.gradientColors,
    required this.checkColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);

    // Draw animated gradient sweep
    if (sweepProgress > 0) {
      canvas.save();

      // Clip to rounded rect
      final clipPath = Path()
        ..addRRect(RRect.fromRectAndRadius(rect.deflate(1), const Radius.circular(5)));
      canvas.clipPath(clipPath);

      // Create sweep gradient that rotates and fills
      final sweepAngle = sweepProgress * 2 * math.pi;

      // For the fill effect: we draw a pie that expands
      final fillPaint = Paint()
        ..shader = SweepGradient(
          center: Alignment.center,
          startAngle: -math.pi / 2,
          endAngle: 3 * math.pi / 2,
          colors: [...gradientColors, gradientColors.first],
          transform: GradientRotation(-math.pi / 2 + sweepAngle * 0.3),
        ).createShader(rect);

      // Draw expanding pie slice
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: size.width),
          -math.pi / 2,
          sweepAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, fillPaint);
      canvas.restore();
    }

    // Draw checkmark
    if (checkProgress > 0) {
      final checkPaint = Paint()
        ..color = checkColor.withValues(alpha: checkProgress)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = Path();

      final startX = size.width * 0.22;
      final startY = size.height * 0.5;
      final midX = size.width * 0.42;
      final midY = size.height * 0.7;
      final endX = size.width * 0.78;
      final endY = size.height * 0.3;

      path.moveTo(startX, startY);

      final firstSegmentProgress = (checkProgress * 2).clamp(0.0, 1.0);
      if (firstSegmentProgress > 0) {
        path.lineTo(
          startX + (midX - startX) * firstSegmentProgress,
          startY + (midY - startY) * firstSegmentProgress,
        );
      }

      final secondSegmentProgress = ((checkProgress - 0.5) * 2).clamp(0.0, 1.0);
      if (secondSegmentProgress > 0) {
        path.lineTo(
          midX + (endX - midX) * secondSegmentProgress,
          midY + (endY - midY) * secondSegmentProgress,
        );
      }

      canvas.drawPath(path, checkPaint);
    }
  }

  @override
  bool shouldRepaint(NeoCheckbox5Painter oldDelegate) {
    return sweepProgress != oldDelegate.sweepProgress ||
        checkProgress != oldDelegate.checkProgress ||
        gradientColors != oldDelegate.gradientColors ||
        checkColor != oldDelegate.checkColor;
  }
}
