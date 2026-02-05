import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Rounded glass checkbox with gradient fill when checked.
///
/// Features a soft rounded rectangle that fills with a vibrant gradient
/// when checked, with a white checkmark appearing on top.
class NeoCheckbox2 extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final double size;

  const NeoCheckbox2({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.size = 24.0,
  });

  @override
  State<NeoCheckbox2> createState() => NeoCheckbox2State();
}

class NeoCheckbox2State extends State<NeoCheckbox2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fillAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.normal,
      vsync: this,
    );

    _fillAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _checkAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(NeoCheckbox2 oldWidget) {
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
              borderRadius: BorderRadius.circular(8),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: glass.blur,
                  sigmaY: glass.blur,
                ),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color.lerp(
                        colors.border,
                        colors.primary,
                        _fillAnimation.value,
                      )!.withValues(alpha: 0.6),
                      width: 1.5,
                    ),
                  ),
                  child: CustomPaint(
                    painter: NeoCheckbox2Painter(
                      fillProgress: _fillAnimation.value,
                      checkProgress: _checkAnimation.value,
                      gradientColors: [
                        colors.primary,
                        colors.secondary,
                        colors.tertiary,
                      ],
                      backgroundColor: colors.surface.withValues(alpha: glass.tintOpacity),
                      checkColor: colors.onPrimary,
                      borderRadius: 8,
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

class NeoCheckbox2Painter extends CustomPainter {
  final double fillProgress;
  final double checkProgress;
  final List<Color> gradientColors;
  final Color backgroundColor;
  final Color checkColor;
  final double borderRadius;

  NeoCheckbox2Painter({
    required this.fillProgress,
    required this.checkProgress,
    required this.gradientColors,
    required this.backgroundColor,
    required this.checkColor,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius - 1.5));

    // Draw background
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRRect(rrect, bgPaint);

    // Draw gradient fill
    if (fillProgress > 0) {
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ).createShader(rect);

      canvas.save();
      canvas.clipRRect(rrect);

      // Scale from center
      final scale = fillProgress;
      canvas.translate(size.width / 2, size.height / 2);
      canvas.scale(scale);
      canvas.translate(-size.width / 2, -size.height / 2);

      canvas.drawRRect(rrect, gradientPaint);
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
  bool shouldRepaint(NeoCheckbox2Painter oldDelegate) {
    return fillProgress != oldDelegate.fillProgress ||
        checkProgress != oldDelegate.checkProgress ||
        gradientColors != oldDelegate.gradientColors ||
        backgroundColor != oldDelegate.backgroundColor ||
        checkColor != oldDelegate.checkColor;
  }
}
