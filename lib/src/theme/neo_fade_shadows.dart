import 'package:flutter/widgets.dart';

class NeoFadeShadows {
  const NeoFadeShadows._();

  static List<BoxShadow> none() => [];

  static List<BoxShadow> sm({Color? color}) => [
        BoxShadow(
          color: color ?? const Color(0x1A000000),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> md({Color? color}) => [
        BoxShadow(
          color: color ?? const Color(0x1A000000),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> lg({Color? color}) => [
        BoxShadow(
          color: color ?? const Color(0x26000000),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> xl({Color? color}) => [
        BoxShadow(
          color: color ?? const Color(0x33000000),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];

  static List<BoxShadow> glow({required Color color, double radius = 16}) => [
        BoxShadow(
          color: color.withValues(alpha: 0.4),
          blurRadius: radius,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> innerGlow({required Color color, double radius = 8}) => [
        BoxShadow(
          color: color.withValues(alpha: 0.3),
          blurRadius: radius,
          spreadRadius: -2,
        ),
      ];
}
