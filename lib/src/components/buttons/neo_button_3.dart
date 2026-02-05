import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Pill-shaped button with gradient on hover/press.
class NeoButton3 extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  const NeoButton3({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
  });

  @override
  State<NeoButton3> createState() => NeoButton3State();
}

class NeoButton3State extends State<NeoButton3> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.normal,
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
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(NeoFadeRadii.full),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
                child: AnimatedContainer(
                  duration: NeoFadeAnimations.fast,
                  padding: const EdgeInsets.symmetric(
                    horizontal: NeoFadeSpacing.lg,
                    vertical: NeoFadeSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    gradient: _isHovered
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colors.primary.withValues(alpha: 0.8),
                              colors.secondary.withValues(alpha: 0.6),
                            ],
                          )
                        : null,
                    color: _isHovered ? null : colors.surface.withValues(alpha: glass.tintOpacity),
                    borderRadius: BorderRadius.circular(NeoFadeRadii.full),
                    border: Border.all(
                      color: _isHovered ? colors.primary : colors.border,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          size: 18,
                          color: _isHovered ? colors.onPrimary : colors.onSurface,
                        ),
                        const SizedBox(width: NeoFadeSpacing.xs),
                      ],
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _isHovered ? colors.onPrimary : colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
