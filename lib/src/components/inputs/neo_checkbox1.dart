import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Glass square checkbox with gradient checkmark and scale animation.
///
/// A poppy, colorful checkbox with tinted glass effect. The checkmark
/// appears with a vibrant gradient and smooth scale animation on check.
class NeoCheckbox1 extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final double size;

  const NeoCheckbox1({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.size = 24.0,
  });

  @override
  State<NeoCheckbox1> createState() => NeoCheckbox1State();
}

class NeoCheckbox1State extends State<NeoCheckbox1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.normal,
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);

    _checkAnimation = CurvedAnimation(
      parent: _controller,
      curve: NeoFadeAnimations.defaultCurve,
    );

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(NeoCheckbox1 oldWidget) {
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
            return Transform.scale(
              scale: _scaleAnimation.value,
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
                      border: Border.all(
                        color: colors.border.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: CustomPaint(
                      painter: NeoCheckbox1Painter(
                        progress: _checkAnimation.value,
                        gradientColors: [
                          colors.primary,
                          colors.secondary,
                          colors.tertiary,
                        ],
                        strokeWidth: 2.5,
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

class NeoCheckbox1Painter extends CustomPainter {
  final double progress;
  final List<Color> gradientColors;
  final double strokeWidth;

  NeoCheckbox1Painter({
    required this.progress,
    required this.gradientColors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    // Checkmark points relative to size
    final startX = size.width * 0.22;
    final startY = size.height * 0.5;
    final midX = size.width * 0.42;
    final midY = size.height * 0.7;
    final endX = size.width * 0.78;
    final endY = size.height * 0.3;

    path.moveTo(startX, startY);

    // First segment of check (going down)
    final firstSegmentProgress = (progress * 2).clamp(0.0, 1.0);
    if (firstSegmentProgress > 0) {
      path.lineTo(
        startX + (midX - startX) * firstSegmentProgress,
        startY + (midY - startY) * firstSegmentProgress,
      );
    }

    // Second segment of check (going up)
    final secondSegmentProgress = ((progress - 0.5) * 2).clamp(0.0, 1.0);
    if (secondSegmentProgress > 0) {
      path.lineTo(
        midX + (endX - midX) * secondSegmentProgress,
        midY + (endY - midY) * secondSegmentProgress,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(NeoCheckbox1Painter oldDelegate) {
    return progress != oldDelegate.progress ||
        gradientColors != oldDelegate.gradientColors ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
