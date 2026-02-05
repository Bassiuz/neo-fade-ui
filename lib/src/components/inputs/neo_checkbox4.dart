import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Glass checkbox with gradient border glow on check.
///
/// A glass checkbox that reveals a vibrant glowing gradient border
/// when checked, with a subtle checkmark inside.
class NeoCheckbox4 extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final double size;

  const NeoCheckbox4({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.size = 24.0,
  });

  @override
  State<NeoCheckbox4> createState() => NeoCheckbox4State();
}

class NeoCheckbox4State extends State<NeoCheckbox4>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.slow,
      vsync: this,
    );

    _glowAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _checkAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(NeoCheckbox4 oldWidget) {
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
            final glowOpacity = _glowAnimation.value * 0.6;

            return Container(
              width: widget.size + 8,
              height: widget.size + 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: _glowAnimation.value > 0
                    ? [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: glowOpacity),
                          blurRadius: 12 * _glowAnimation.value,
                          spreadRadius: 2 * _glowAnimation.value,
                        ),
                        BoxShadow(
                          color: colors.secondary.withValues(alpha: glowOpacity * 0.7),
                          blurRadius: 8 * _glowAnimation.value,
                          spreadRadius: 1 * _glowAnimation.value,
                          offset: const Offset(2, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: ClipRRect(
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
                      ),
                      child: CustomPaint(
                        painter: NeoCheckbox4Painter(
                          glowProgress: _glowAnimation.value,
                          checkProgress: _checkAnimation.value,
                          gradientColors: [
                            colors.primary,
                            colors.secondary,
                            colors.tertiary,
                          ],
                          borderColor: colors.border,
                        ),
                      ),
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
              const SizedBox(width: 4),
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

class NeoCheckbox4Painter extends CustomPainter {
  final double glowProgress;
  final double checkProgress;
  final List<Color> gradientColors;
  final Color borderColor;

  NeoCheckbox4Painter({
    required this.glowProgress,
    required this.checkProgress,
    required this.gradientColors,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));

    // Draw gradient border
    const borderWidth = 2.0;

    // Interpolate between regular border and gradient border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    if (glowProgress > 0) {
      borderPaint.shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ).createShader(rect);
    } else {
      borderPaint.color = borderColor.withValues(alpha: 0.5);
    }

    canvas.drawRRect(rrect.deflate(borderWidth / 2), borderPaint);

    // Draw checkmark with gradient
    if (checkProgress > 0) {
      final checkPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ).createShader(rect)
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
  bool shouldRepaint(NeoCheckbox4Painter oldDelegate) {
    return glowProgress != oldDelegate.glowProgress ||
        checkProgress != oldDelegate.checkProgress ||
        gradientColors != oldDelegate.gradientColors ||
        borderColor != oldDelegate.borderColor;
  }
}
