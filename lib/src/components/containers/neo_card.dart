import 'package:flutter/widgets.dart';

import 'neo_card_top_border.dart';
import 'neo_card_glow_outline.dart';
import 'neo_card_left_accent.dart';
import 'neo_card_corner_splash.dart';
import 'neo_card_bottom_fade.dart';
import 'neo_card_diagonal_stripe.dart';
import 'neo_card_pulsing_glow.dart';

/// A collection of glass-effect card variants with different gradient decorations.
///
/// Use the named constructors to create different card styles:
/// - [NeoCard.topBorder] - Gradient stripe at top
/// - [NeoCard.glowOutline] - Sweep gradient border (optionally animated)
/// - [NeoCard.leftAccent] - Vertical stripe on left
/// - [NeoCard.cornerSplash] - Radial gradient in corner
/// - [NeoCard.bottomFade] - Bottom gradient fade
/// - [NeoCard.diagonalStripe] - Diagonal stripe across
/// - [NeoCard.pulsingGlow] - Animated pulsing shadow
abstract class NeoCard {
  /// Creates a glass card with a subtle gradient top border.
  ///
  /// This card combines the tinted glass effect with a delicate gradient
  /// accent along the top edge, creating an elegant and modern appearance.
  static Widget topBorder({
    Key? key,
    Widget? child,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    double? gradientBorderHeight,
    double? borderWidth,
  }) {
    return NeoCardTopBorder(
      key: key,
      padding: padding,
      borderRadius: borderRadius,
      gradientBorderHeight: gradientBorderHeight,
      borderWidth: borderWidth,
      child: child,
    );
  }

  /// Creates a glass card with a glowing gradient outline.
  ///
  /// This card features a vibrant gradient border that wraps around the entire
  /// card with a subtle glow effect, creating a striking visual impact.
  ///
  /// Set [animated] to true to enable the shimmer animation effect.
  static Widget glowOutline({
    Key? key,
    Widget? child,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    double? borderWidth,
    bool animated = false,
    Duration? animationDuration,
  }) {
    return NeoCardGlowOutline(
      key: key,
      padding: padding,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      animated: animated,
      animationDuration: animationDuration,
      child: child,
    );
  }

  /// Creates a glass card with a gradient accent stripe on the left side.
  ///
  /// This card features a vertical gradient stripe along the left edge,
  /// providing a colorful accent while maintaining the elegant glass aesthetic.
  static Widget leftAccent({
    Key? key,
    Widget? child,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    double? stripeWidth,
  }) {
    return NeoCardLeftAccent(
      key: key,
      padding: padding,
      borderRadius: borderRadius,
      stripeWidth: stripeWidth,
      child: child,
    );
  }

  /// Creates a glass card with a corner gradient accent (top-right splash).
  ///
  /// This card features a vibrant gradient splash in the top-right corner,
  /// creating a dynamic and eye-catching visual effect while maintaining
  /// the glass aesthetic.
  static Widget cornerSplash({
    Key? key,
    Widget? child,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    double? splashSize,
  }) {
    return NeoCardCornerSplash(
      key: key,
      padding: padding,
      borderRadius: borderRadius,
      splashSize: splashSize,
      child: child,
    );
  }

  /// Creates a glass card with a bottom gradient fade.
  ///
  /// This card features a gradient fade effect at the bottom that transitions
  /// from transparent to a vibrant gradient, creating an elegant finishing touch.
  static Widget bottomFade({
    Key? key,
    Widget? child,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    double? fadeHeight,
  }) {
    return NeoCardBottomFade(
      key: key,
      padding: padding,
      borderRadius: borderRadius,
      fadeHeight: fadeHeight,
      child: child,
    );
  }

  /// Creates a glass card with a diagonal gradient stripe across.
  ///
  /// This card features a vibrant diagonal gradient stripe that cuts across
  /// the card from corner to corner, creating a bold and dynamic visual effect.
  static Widget diagonalStripe({
    Key? key,
    Widget? child,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    double? stripeWidth,
  }) {
    return NeoCardDiagonalStripe(
      key: key,
      padding: padding,
      borderRadius: borderRadius,
      stripeWidth: stripeWidth,
      child: child,
    );
  }

  /// Creates a glass card with a pulsing gradient glow shadow.
  ///
  /// This card features an animated pulsing glow effect that creates
  /// a vibrant gradient shadow around the card, adding a dynamic and
  /// attention-grabbing visual effect.
  static Widget pulsingGlow({
    Key? key,
    Widget? child,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Duration? pulseDuration,
    double? maxGlowRadius,
  }) {
    return NeoCardPulsingGlow(
      key: key,
      padding: padding,
      borderRadius: borderRadius,
      pulseDuration: pulseDuration,
      maxGlowRadius: maxGlowRadius,
      child: child,
    );
  }
}
