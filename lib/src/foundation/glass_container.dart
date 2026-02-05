import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../theme/neo_fade_theme.dart';
import 'inner_border.dart';

class GlassContainer extends StatelessWidget {
  final Widget? child;
  final double? blur;
  final Color? tint;
  final double? tintOpacity;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final List<BoxShadow>? shadows;

  const GlassContainer({
    super.key,
    this.child,
    this.blur,
    this.tint,
    this.tintOpacity,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.constraints,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final effectiveBlur = blur ?? glass.blur;
    final effectiveTint = tint ?? colors.surface;
    final effectiveTintOpacity = tintOpacity ?? glass.tintOpacity;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12);
    final effectiveBorderColor = borderColor ??
        (colors.isLight
            ? const Color(0xFFFFFFFF).withValues(alpha: glass.borderOpacity)
            : const Color(0xFFFFFFFF).withValues(alpha: glass.borderOpacity));
    final effectiveBorderWidth = borderWidth ?? glass.innerBorderWidth;

    Widget content = Container(
      width: width,
      height: height,
      constraints: constraints,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveTint.withValues(alpha: effectiveTintOpacity),
        borderRadius: effectiveBorderRadius,
        boxShadow: shadows,
      ),
      child: child,
    );

    if (effectiveBorderWidth > 0) {
      content = InnerBorder(
        color: effectiveBorderColor,
        width: effectiveBorderWidth,
        borderRadius: effectiveBorderRadius,
        child: content,
      );
    }

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: effectiveBlur,
          sigmaY: effectiveBlur,
        ),
        child: content,
      ),
    );
  }
}
