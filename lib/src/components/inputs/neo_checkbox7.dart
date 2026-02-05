import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Glass checkbox with bouncy check animation.
///
/// A playful glass checkbox with an elastic, bouncy animation when
/// the checkmark appears, using spring physics for a lively feel.
class NeoCheckbox7 extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final double size;

  const NeoCheckbox7({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.size = 24.0,
  });

  @override
  State<NeoCheckbox7> createState() => NeoCheckbox7State();
}

class NeoCheckbox7State extends State<NeoCheckbox7>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _checkAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.verySlow,
      vsync: this,
    );

    _bounceAnimation = CurvedAnimation(
      parent: _controller,
      curve: NeoFadeAnimations.bounceCurve,
    );

    _checkAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.85)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
    ]).animate(_controller);

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(NeoCheckbox7 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward(from: 0);
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
                      gradient: _bounceAnimation.value > 0
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colors.primary.withValues(alpha: glass.tintOpacity * _bounceAnimation.value),
                                colors.secondary.withValues(alpha: glass.tintOpacity * _bounceAnimation.value),
                              ],
                            )
                          : null,
                      color: _bounceAnimation.value <= 0
                          ? colors.surface.withValues(alpha: glass.tintOpacity)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Color.lerp(
                          colors.border,
                          colors.primary,
                          _bounceAnimation.value,
                        )!.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                    ),
                    child: CustomPaint(
                      painter: NeoCheckbox7Painter(
                        checkProgress: _checkAnimation.value,
                        bounceProgress: _bounceAnimation.value,
                        checkColor: colors.onPrimary,
                        gradientColors: [
                          colors.primary,
                          colors.secondary,
                          colors.tertiary,
                        ],
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

class NeoCheckbox7Painter extends CustomPainter {
  final double checkProgress;
  final double bounceProgress;
  final Color checkColor;
  final List<Color> gradientColors;

  NeoCheckbox7Painter({
    required this.checkProgress,
    required this.bounceProgress,
    required this.checkColor,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (checkProgress <= 0) return;

    // Use white check when filled, gradient when not
    final checkPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (bounceProgress > 0.5) {
      checkPaint.color = checkColor;
    } else {
      checkPaint.shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    }

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

  @override
  bool shouldRepaint(NeoCheckbox7Painter oldDelegate) {
    return checkProgress != oldDelegate.checkProgress ||
        bounceProgress != oldDelegate.bounceProgress ||
        checkColor != oldDelegate.checkColor ||
        gradientColors != oldDelegate.gradientColors;
  }
}
