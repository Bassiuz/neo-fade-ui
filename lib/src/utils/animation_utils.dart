import 'package:flutter/widgets.dart';

class NeoFadeAnimations {
  const NeoFadeAnimations._();

  static const Duration fast = Duration(milliseconds: 100);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);
  static const Duration verySlow = Duration(milliseconds: 500);

  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve enterCurve = Curves.easeOut;
  static const Curve exitCurve = Curves.easeIn;
  static const Curve bounceCurve = Curves.elasticOut;

  static const double hoverScale = 1.02;
  static const double pressedScale = 0.98;
  static const double disabledOpacity = 0.5;
  static const double hoverOpacityIncrease = 0.1;
  static const double pressedOpacityDecrease = 0.1;
}
