import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NeoFadeTheme(
        data: NeoFadeThemeData.fromColors(
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFFF472B6),
          tertiary: const Color(0xFF22D3EE),
          brightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NeoButtonFilled(
                  label: 'Hello Neo Fade',
                  onPressed: () {},
                ),
                const SizedBox(height: 16),
                const NeoCardTopBorder(
                  child: Text('A glass card with a gradient top border'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
