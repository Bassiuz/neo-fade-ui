import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../foundation/inner_border.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';

/// A glass card with a bottom gradient fade.
///
/// This card features a gradient fade effect at the bottom that transitions
/// from transparent to a vibrant gradient, creating an elegant finishing touch.
class NeoCardBottomFade extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? fadeHeight;

  const NeoCardBottomFade({
    super.key,
    this.child,
    this.padding,
    this.borderRadius,
    this.fadeHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final effectivePadding = padding ?? const EdgeInsets.all(NeoFadeSpacing.cardPadding);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(NeoFadeRadii.card);
    final effectiveFadeHeight = fadeHeight ?? NeoFadeSpacing.xl;

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: glass.blur,
          sigmaY: glass.blur,
        ),
        child: InnerBorder(
          color: const Color(0xFFFFFFFF).withValues(alpha: glass.borderOpacity),
          width: glass.innerBorderWidth,
          borderRadius: effectiveBorderRadius,
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: glass.tintOpacity),
              borderRadius: effectiveBorderRadius,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: effectivePadding,
                  child: child,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: effectiveFadeHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colors.surface.withValues(alpha: 0.0),
                          colors.primary.withValues(alpha: 0.15),
                          colors.secondary.withValues(alpha: 0.25),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: effectiveBorderRadius.bottomLeft,
                        bottomRight: effectiveBorderRadius.bottomRight,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: NeoFadeSpacing.xxs,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          colors.primary,
                          colors.secondary,
                          colors.tertiary,
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: effectiveBorderRadius.bottomLeft,
                        bottomRight: effectiveBorderRadius.bottomRight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
