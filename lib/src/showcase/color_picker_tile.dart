import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// A color picker tile that displays a color swatch and opens a color picker dialog.
class ColorPickerTile extends StatelessWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerTile({
    super.key,
    required this.label,
    required this.color,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);

    return GlassContainer(
      padding: const EdgeInsets.all(NeoFadeSpacing.md),
      borderRadius: NeoFadeRadii.mdRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.typography.labelMedium),
          const SizedBox(height: NeoFadeSpacing.sm),
          GestureDetector(
            onTap: () => showColorPicker(context),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: NeoFadeRadii.smRadius,
                border: Border.all(color: theme.colors.border, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showColorPicker(BuildContext context) {
    final presetColors = [
      const Color(0xFF6366F1),
      const Color(0xFFF472B6),
      const Color(0xFF22D3EE),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF8B5CF6),
      const Color(0xFF3B82F6),
      const Color(0xFF14B8A6),
      const Color(0xFFEC4899),
      const Color(0xFFF97316),
      const Color(0xFF84CC16),
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeoFadeTheme.of(context).colors.surface,
        title: Text('Select $label Color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: presetColors.map((presetColor) {
            return GestureDetector(
              onTap: () {
                onColorChanged(presetColor);
                Navigator.of(context).pop();
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: presetColor,
                  borderRadius: BorderRadius.circular(8),
                  border: presetColor == color
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
