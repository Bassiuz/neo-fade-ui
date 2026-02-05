import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_tooltip.dart';

/// The bubble widget that displays the tooltip content.
class NeoTooltipBubble extends StatelessWidget {
  final String message;
  final NeoTooltipPosition position;

  const NeoTooltipBubble({
    super.key,
    required this.message,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (position == NeoTooltipPosition.bottom)
          NeoTooltipPointer(
            colors: [colors.primary, colors.secondary],
            isPointingUp: true,
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(NeoFadeRadii.sm),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: glass.blur,
              sigmaY: glass.blur,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: NeoFadeSpacing.sm,
                vertical: NeoFadeSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: glass.tintOpacity + 0.2),
                borderRadius: BorderRadius.circular(NeoFadeRadii.sm),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message,
                style: theme.typography.bodySmall.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ),
          ),
        ),
        if (position == NeoTooltipPosition.top)
          NeoTooltipPointer(
            colors: [colors.primary, colors.secondary],
            isPointingUp: false,
          ),
      ],
    );
  }
}

/// The gradient pointer/arrow for the tooltip.
class NeoTooltipPointer extends StatelessWidget {
  final List<Color> colors;
  final bool isPointingUp;

  const NeoTooltipPointer({
    super.key,
    required this.colors,
    required this.isPointingUp,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(12, 6),
      painter: NeoTooltipPointerPainter(
        colors: colors,
        isPointingUp: isPointingUp,
      ),
    );
  }
}

/// Custom painter for the tooltip pointer.
class NeoTooltipPointerPainter extends CustomPainter {
  final List<Color> colors;
  final bool isPointingUp;

  NeoTooltipPointerPainter({
    required this.colors,
    required this.isPointingUp,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: colors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    if (isPointingUp) {
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(NeoTooltipPointerPainter oldDelegate) {
    return colors != oldDelegate.colors ||
        isPointingUp != oldDelegate.isPointingUp;
  }
}
