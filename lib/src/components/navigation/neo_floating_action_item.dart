import 'package:flutter/widgets.dart';

/// Data class for a floating action item.
class NeoFloatingActionItem {
  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;

  const NeoFloatingActionItem({
    required this.icon,
    this.label,
    this.onPressed,
  });
}
