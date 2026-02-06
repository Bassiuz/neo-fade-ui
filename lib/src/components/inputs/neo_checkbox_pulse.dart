import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_checkbox_pulse_painter.dart';

/// Checkbox with gradient shadow pulse when checked.
///
/// A glass checkbox that emits a pulsing gradient shadow effect
/// when checked, creating a glowing, vibrant appearance.
class NeoCheckboxPulse extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final double size;

  const NeoCheckboxPulse({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.size = 24.0,
  });

  @override
  State<NeoCheckboxPulse> createState() => NeoCheckboxPulseState();
}

class NeoCheckboxPulseState extends State<NeoCheckboxPulse>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _pulseController;
  late Animation<double> _checkAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      duration: NeoFadeAnimations.normal,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: NeoFadeAnimations.defaultCurve,
    );

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.6)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_pulseController);

    if (widget.value) {
      _checkController.value = 1.0;
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(NeoCheckboxPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _checkController.forward();
        _pulseController.repeat(reverse: true);
      } else {
        _checkController.reverse();
        _pulseController.stop();
        _pulseController.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    _pulseController.dispose();
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
          animation: Listenable.merge([_checkController, _pulseController]),
          builder: (context, child) {
            final pulseValue = _checkAnimation.value * _pulseAnimation.value;

            return Container(
              width: widget.size + 16,
              height: widget.size + 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: pulseValue > 0
                    ? [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.4 * pulseValue),
                          blurRadius: 16 * pulseValue,
                          spreadRadius: 2 * pulseValue,
                        ),
                        BoxShadow(
                          color: colors.secondary.withValues(alpha: 0.3 * pulseValue),
                          blurRadius: 12 * pulseValue,
                          spreadRadius: 1 * pulseValue,
                          offset: Offset(4 * pulseValue, 4 * pulseValue),
                        ),
                        BoxShadow(
                          color: colors.tertiary.withValues(alpha: 0.2 * pulseValue),
                          blurRadius: 8 * pulseValue,
                          spreadRadius: 0,
                          offset: Offset(-3 * pulseValue, 3 * pulseValue),
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
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colors.surface.withValues(alpha: glass.tintOpacity),
                            Color.lerp(
                              colors.surface,
                              colors.primary,
                              _checkAnimation.value * 0.2,
                            )!.withValues(alpha: glass.tintOpacity),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Color.lerp(
                            colors.border,
                            colors.primary,
                            _checkAnimation.value,
                          )!.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                      ),
                      child: CustomPaint(
                        painter: NeoCheckboxPulsePainter(
                          checkProgress: _checkAnimation.value,
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
