import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import 'src/showcase/component_browser_home.dart';

void main() {
  runApp(const ComponentBrowserApp());
}

/// The main component browser application.
class ComponentBrowserApp extends StatefulWidget {
  const ComponentBrowserApp({super.key});

  @override
  State<ComponentBrowserApp> createState() => ComponentBrowserAppState();
}

class ComponentBrowserAppState extends State<ComponentBrowserApp> {
  Color primaryColor = const Color(0xFF6366F1);
  Color secondaryColor = const Color(0xFFF472B6);
  Color tertiaryColor = const Color(0xFF22D3EE);
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeThemeData.fromColors(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    );

    return NeoFadeTheme(
      data: theme,
      child: MaterialApp(
        title: 'Neo Fade UI - Component Browser',
        debugShowCheckedModeBanner: false,
        theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        home: ComponentBrowserHome(
          isDarkMode: isDarkMode,
          onThemeToggle: () => setState(() => isDarkMode = !isDarkMode),
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
          tertiaryColor: tertiaryColor,
          onPrimaryColorChanged: (color) => setState(() => primaryColor = color),
          onSecondaryColorChanged: (color) => setState(() => secondaryColor = color),
          onTertiaryColorChanged: (color) => setState(() => tertiaryColor = color),
        ),
      ),
    );
  }
}
