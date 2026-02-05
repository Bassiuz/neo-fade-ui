import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Pill-shaped compact number selector.
class NeoNumberSelector3 extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;

  const NeoNumberSelector3({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.step = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;
    final typography = theme.typography;

    final canDecrement = value > min;
    final canIncrement = value < max;

    return ClipRRect(
      borderRadius: BorderRadius.circular(NeoFadeRadii.full),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: glass.tintOpacity),
            borderRadius: BorderRadius.circular(NeoFadeRadii.full),
            border: Border.all(
              color: colors.border.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CircleButton(
                icon: const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                enabled: canDecrement,
                onPressed: () => onChanged(value - step),
                colors: colors,
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 50),
                padding: const EdgeInsets.symmetric(horizontal: NeoFadeSpacing.sm),
                child: Text(
                  value.toString(),
                  style: typography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              _CircleButton(
                icon: const IconData(0xe145, fontFamily: 'MaterialIcons'),
                enabled: canIncrement,
                onPressed: () => onChanged(value + step),
                colors: colors,
                isGradient: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatefulWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;
  final dynamic colors;
  final bool isGradient;

  const _CircleButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
    required this.colors,
    this.isGradient = false,
  });

  @override
  State<_CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<_CircleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.fast,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => _controller.forward() : null,
      onTapUp: widget.enabled
          ? (_) {
              _controller.reverse();
              widget.onPressed();
            }
          : null,
      onTapCancel: widget.enabled ? () => _controller.reverse() : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.1),
            child: child,
          );
        },
        child: AnimatedOpacity(
          duration: NeoFadeAnimations.fast,
          opacity: widget.enabled ? 1.0 : 0.4,
          child: Container(
            padding: const EdgeInsets.all(NeoFadeSpacing.sm),
            decoration: BoxDecoration(
              gradient: widget.isGradient && widget.enabled
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [widget.colors.primary, widget.colors.secondary],
                    )
                  : null,
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: widget.isGradient && widget.enabled
                  ? widget.colors.onPrimary
                  : widget.colors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
