import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Large prominent number selector with gradient value display.
class NeoNumberSelector4 extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;
  final String? label;
  final String? unit;

  const NeoNumberSelector4({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.label,
    this.unit,
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
      borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
        child: Container(
          padding: const EdgeInsets.all(NeoFadeSpacing.lg),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: glass.tintOpacity),
            borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
            border: Border.all(
              color: colors.border.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label != null) ...[
                Text(
                  label!,
                  style: typography.labelMedium.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: NeoFadeSpacing.md),
              ],
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _LargeStepButton(
                    icon: const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                    enabled: canDecrement,
                    onPressed: () => onChanged(value - step),
                    colors: colors,
                  ),
                  const SizedBox(width: NeoFadeSpacing.lg),
                  Container(
                    constraints: const BoxConstraints(minWidth: 100),
                    padding: const EdgeInsets.symmetric(
                      vertical: NeoFadeSpacing.md,
                      horizontal: NeoFadeSpacing.lg,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colors.primary.withValues(alpha: 0.15),
                          colors.secondary.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(NeoFadeRadii.md),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.2),
                          blurRadius: NeoFadeSpacing.md,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          value.toString(),
                          style: typography.headlineLarge.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.primary,
                          ),
                        ),
                        if (unit != null) ...[
                          const SizedBox(width: NeoFadeSpacing.xs),
                          Text(
                            unit!,
                            style: typography.bodyMedium.copyWith(
                              color: colors.primary.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: NeoFadeSpacing.lg),
                  _LargeStepButton(
                    icon: const IconData(0xe145, fontFamily: 'MaterialIcons'),
                    enabled: canIncrement,
                    onPressed: () => onChanged(value + step),
                    colors: colors,
                    isPrimary: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LargeStepButton extends StatefulWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;
  final dynamic colors;
  final bool isPrimary;

  const _LargeStepButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
    required this.colors,
    this.isPrimary = false,
  });

  @override
  State<_LargeStepButton> createState() => _LargeStepButtonState();
}

class _LargeStepButtonState extends State<_LargeStepButton>
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
            padding: const EdgeInsets.all(NeoFadeSpacing.md),
            decoration: BoxDecoration(
              gradient: widget.isPrimary && widget.enabled
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [widget.colors.primary, widget.colors.secondary],
                    )
                  : null,
              color: widget.isPrimary ? null : widget.colors.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(NeoFadeRadii.md),
              border: Border.all(
                color: widget.isPrimary
                    ? widget.colors.primary.withValues(alpha: 0.5)
                    : widget.colors.border,
                width: 1,
              ),
              boxShadow: widget.isPrimary && widget.enabled
                  ? [
                      BoxShadow(
                        color: widget.colors.primary.withValues(alpha: 0.3),
                        blurRadius: NeoFadeSpacing.sm,
                        spreadRadius: 0,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              widget.icon,
              size: 28,
              color: widget.isPrimary && widget.enabled
                  ? widget.colors.onPrimary
                  : widget.colors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
