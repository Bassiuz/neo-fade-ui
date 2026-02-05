import 'package:flutter/widgets.dart';

/// Item for NeoDropdown.
class NeoDropdownItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const NeoDropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });
}
