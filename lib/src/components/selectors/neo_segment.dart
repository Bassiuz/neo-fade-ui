import 'package:flutter/widgets.dart';

/// Represents a segment in a segmented control.
class NeoSegment<T> {
  final T value;
  final String label;
  final IconData? icon;

  const NeoSegment({
    required this.value,
    required this.label,
    this.icon,
  });
}
