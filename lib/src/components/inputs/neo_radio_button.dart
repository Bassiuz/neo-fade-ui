import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Radio button with gradient fill when selected.
///
/// A Neo Fade styled radio button that displays a gradient-filled
/// inner circle when selected, with smooth animation transitions.
class NeoRadioButton<T> extends StatefulWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String? label;
  final double size;

  const NeoRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
    this.size = 24.0,
  });

  @override
  State<NeoRadioButton<T>> createState() => NeoRadioButtonState<T>();
}

class NeoRadioButtonState<T> extends State<NeoRadioButton<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fillAnimation;

  bool get _isSelected => widget.value == widget.groupValue;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.normal,
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);

    _fillAnimation = CurvedAnimation(
      parent: _controller,
      curve: NeoFadeAnimations.defaultCurve,
    );

    if (_isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(NeoRadioButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final wasSelected = oldWidget.value == oldWidget.groupValue;
    if (_isSelected != wasSelected) {
      if (_isSelected) {
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
    if (!_isSelected) {
      widget.onChanged?.call(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;
    final isEnabled = widget.onChanged != null;

    final radio = GestureDetector(
      onTap: isEnabled ? _handleTap : null,
      child: MouseRegion(
        cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: ClipOval(
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
                      border: Border.all(
                        color: _isSelected
                            ? colors.primary.withValues(alpha: 0.8)
                            : colors.border.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: AnimatedContainer(
                        duration: NeoFadeAnimations.fast,
                        width: widget.size * 0.5 * _fillAnimation.value,
                        height: widget.size * 0.5 * _fillAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: _fillAnimation.value > 0
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    colors.primary,
                                    colors.secondary,
                                  ],
                                )
                              : null,
                          boxShadow: _fillAnimation.value > 0
                              ? [
                                  BoxShadow(
                                    color: colors.primary.withValues(alpha: 0.4),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
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
              radio,
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

    return radio;
  }
}
