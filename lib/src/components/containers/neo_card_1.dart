import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../foundation/inner_border.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';

/// A glass card with a subtle gradient top border.
///
/// This card combines the tinted glass effect with a delicate gradient
/// accent along the top edge, creating an elegant and modern appearance.
class NeoCard1 extends StatelessWidget {
  final Widget? child;

  /// Optional padding. Defaults to NeoFadeSpacing.cardPadding.
  final EdgeInsetsGeometry? padding;

  /// Optional border radius. Defaults to NeoFadeRadii.card.
  final BorderRadius? borderRadius;

  /// Optional gradient border height at the top. Defaults to NeoFadeSpacing.xxs.
  final double? gradientBorderHeight;

  /// Optional inner border width. Defaults to theme glass.innerBorderWidth.
  final double? borderWidth;

  const NeoCard1({
    super.key,
    this.child,
    this.padding,
    this.borderRadius,
    this.gradientBorderHeight,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final effectivePadding = padding ?? const EdgeInsets.all(NeoFadeSpacing.cardPadding);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(NeoFadeRadii.card);
    final effectiveGradientHeight = gradientBorderHeight ?? NeoFadeSpacing.xxs;
    final effectiveBorderWidth = borderWidth ?? glass.innerBorderWidth;

    final gradientColors = [
      colors.primary,
      colors.secondary,
      colors.tertiary,
    ];

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: glass.blur,
          sigmaY: glass.blur,
        ),
        child: InnerBorder(
          color: const Color(0xFFFFFFFF).withValues(alpha: glass.borderOpacity),
          width: effectiveBorderWidth,
          borderRadius: effectiveBorderRadius,
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: glass.tintOpacity),
              borderRadius: effectiveBorderRadius,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: effectiveGradientHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: gradientColors,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: effectiveBorderRadius.topLeft,
                      topRight: effectiveBorderRadius.topRight,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: effectivePadding,
                    child: child,
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
