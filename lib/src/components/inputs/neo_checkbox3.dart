import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Circular checkbox with gradient ring that fills inward.
///
/// A circular glass checkbox featuring a vibrant gradient ring that
/// animates inward when checked, revealing a centered dot.
class NeoCheckbox3 extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final double size;

  const NeoCheckbox3({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.size = 24.0,
  });

  @override
  State<NeoCheckbox3> createState() => NeoCheckbox3State();
}

class NeoCheckbox3State extends State<NeoCheckbox3>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _ringAnimation;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.slow,
      vsync: this,
    );

    _ringAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    _fillAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(NeoCheckbox3 oldWidget) {
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
            return ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: glass.blur,
                  sigmaY: glass.blur,
                ),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surface.withValues(alpha: glass.tintOpacity),
                  ),
                  child: CustomPaint(
                    painter: NeoCheckbox3Painter(
                      ringProgress: _ringAnimation.value,
                      fillProgress: _fillAnimation.value,
                      gradientColors: [
                        colors.primary,
                        colors.secondary,
                        colors.tertiary,
                      ],
                      borderColor: colors.border.withValues(alpha: 0.5),
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

class NeoCheckbox3Painter extends CustomPainter {
  final double ringProgress;
  final double fillProgress;
  final List<Color> gradientColors;
  final Color borderColor;

  NeoCheckbox3Painter({
    required this.ringProgress,
    required this.fillProgress,
    required this.gradientColors,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw base border ring
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius - 1, borderPaint);

    // Draw gradient ring (sweeps around)
    if (ringProgress > 0) {
      final ringPaint = Paint()
        ..shader = SweepGradient(
          colors: [...gradientColors, gradientColors.first],
          startAngle: -math.pi / 2,
          endAngle: 3 * math.pi / 2,
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 2),
        -math.pi / 2,
        2 * math.pi * ringProgress,
        false,
        ringPaint,
      );
    }

    // Draw inner fill circle
    if (fillProgress > 0) {
      final fillRadius = (radius - 6) * fillProgress;

      final fillPaint = Paint()
        ..shader = RadialGradient(
          colors: gradientColors,
        ).createShader(Rect.fromCircle(center: center, radius: fillRadius));

      canvas.drawCircle(center, fillRadius, fillPaint);
    }
  }

  @override
  bool shouldRepaint(NeoCheckbox3Painter oldDelegate) {
    return ringProgress != oldDelegate.ringProgress ||
        fillProgress != oldDelegate.fillProgress ||
        gradientColors != oldDelegate.gradientColors ||
        borderColor != oldDelegate.borderColor;
  }
}
