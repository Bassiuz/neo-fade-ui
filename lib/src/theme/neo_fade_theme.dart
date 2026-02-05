import 'package:flutter/widgets.dart';

import 'neo_fade_theme_data.dart';

class NeoFadeTheme extends InheritedWidget {
  final NeoFadeThemeData data;

  const NeoFadeTheme({
    super.key,
    required this.data,
    required super.child,
  });

  static NeoFadeThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<NeoFadeTheme>();
    assert(theme != null, 'No NeoFadeTheme found in context');
    return theme!.data;
  }

  static NeoFadeThemeData? maybeOf(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<NeoFadeTheme>();
    return theme?.data;
  }

  @override
  bool updateShouldNotify(NeoFadeTheme oldWidget) {
    return data != oldWidget.data;
  }
}
