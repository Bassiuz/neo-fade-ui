import 'package:flutter/widgets.dart';

/// Data class representing an item in the bottom navigation bar.
class NeoBottomNavItem {
  final IconData icon;
  final String? label;

  const NeoBottomNavItem({required this.icon, this.label});
}
