import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Minimal checkbox where just the gradient checkmark appears.
///
/// A minimalist design with a subtle glass container where only
/// a vibrant gradient checkmark animates in when checked.
class NeoCheckbox6 extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final double size;

  const NeoCheckbox6({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.size = 24.0,
  });

  @override
  State<NeoCheckbox6> createState() => NeoCheckbox6State();
}

class NeoCheckbox6State extends State<NeoCheckbox6>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _checkAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.normal,
      vsync: this,
    );

    _checkAnimation = CurvedAnimation(
      parent: _controller,
      curve: NeoFadeAnimations.defaultCurve,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(NeoCheckbox6 oldWidget) {
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
              borderRadius: BorderRadius.circular(4),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: glass.blur * 0.5,
                  sigmaY: glass.blur * 0.5,
                ),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: glass.tintOpacity * 0.3),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: colors.borderSubtle.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: CustomPaint(
                    painter: NeoCheckbox6Painter(
                      checkProgress: _checkAnimation.value,
                      opacity: _opacityAnimation.value,
                      gradientColors: [
                        colors.primary,
                        colors.secondary,
                        colors.tertiary,
                      ],
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

class NeoCheckbox6Painter extends CustomPainter {
  final double checkProgress;
  final double opacity;
  final List<Color> gradientColors;

  NeoCheckbox6Painter({
    required this.checkProgress,
    required this.opacity,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (checkProgress <= 0) return;

    final checkPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    // Larger checkmark for minimal style
    final startX = size.width * 0.18;
    final startY = size.height * 0.5;
    final midX = size.width * 0.4;
    final midY = size.height * 0.75;
    final endX = size.width * 0.82;
    final endY = size.height * 0.25;

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

    // Apply opacity
    canvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Color.fromRGBO(0, 0, 0, opacity),
    );
    canvas.drawPath(path, checkPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(NeoCheckbox6Painter oldDelegate) {
    return checkProgress != oldDelegate.checkProgress ||
        opacity != oldDelegate.opacity ||
        gradientColors != oldDelegate.gradientColors;
  }
}
