import 'package:flutter/widgets.dart';

class NeoFadeRadii {
  const NeoFadeRadii._();

  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double full = 9999.0;

  static BorderRadius get noneRadius => BorderRadius.zero;
  static BorderRadius get xsRadius => BorderRadius.circular(xs);
  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get xlRadius => BorderRadius.circular(xl);
  static BorderRadius get xxlRadius => BorderRadius.circular(xxl);
  static BorderRadius get fullRadius => BorderRadius.circular(full);

  static const double button = md;
  static const double card = lg;
  static const double dialog = xl;
  static const double input = sm;
  static const double checkbox = xs;
  static const double switchTrack = full;
  static const double switchThumb = full;
}
