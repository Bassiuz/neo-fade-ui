import 'package:flutter/widgets.dart';

import 'neo_feature_card_icon_centered.dart';
import 'neo_feature_card_icon_header.dart';
import 'neo_feature_card_icon_left.dart';
import 'neo_feature_card_icon_top.dart';

/// A feature card widget with multiple style variants.
///
/// Use the named constructors to create different styles:
/// - [NeoFeatureCard.iconTop] - Icon above text
/// - [NeoFeatureCard.iconLeft] - Icon on left, horizontal
/// - [NeoFeatureCard.iconCentered] - Centered icon with glow
/// - [NeoFeatureCard.iconHeader] - Full-width gradient header
abstract class NeoFeatureCard extends StatelessWidget {
  const NeoFeatureCard._();

  /// Creates a feature card with gradient icon container above text.
  static Widget iconTop({
    Key? key,
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return NeoFeatureCardIconTop(
      key: key,
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
    );
  }

  /// Creates a horizontal feature card with icon on the left.
  static Widget iconLeft({
    Key? key,
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return NeoFeatureCardIconLeft(
      key: key,
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
    );
  }

  /// Creates a feature card with large centered icon and gradient glow.
  static Widget iconCentered({
    Key? key,
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return NeoFeatureCardIconCentered(
      key: key,
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
    );
  }

  /// Creates a feature card with gradient top section containing icon.
  static Widget iconHeader({
    Key? key,
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return NeoFeatureCardIconHeader(
      key: key,
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
    );
  }
}
