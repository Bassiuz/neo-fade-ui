import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_checkbox_glow_border_painter.dart';

/// Glass checkbox with gradient border glow on check.
///
/// A glass checkbox that reveals a vibrant glowing gradient border
/// when checked, with a subtle checkmark inside.
class NeoCheckboxGlowBorder extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final double size;

  const NeoCheckboxGlowBorder({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.size = 24.0,
  });

  @override
  State<NeoCheckboxGlowBorder> createState() => NeoCheckboxGlowBorderState();
}

class NeoCheckboxGlowBorderState extends State<NeoCheckboxGlowBorder>
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
  void didUpdateWidget(NeoCheckboxGlowBorder oldWidget) {
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
                        painter: NeoCheckboxGlowBorderPainter(
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
