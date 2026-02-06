import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// Emoji picker showcase page displaying all three picker variants.
class ShowcaseEmojiPage extends StatefulWidget {
  const ShowcaseEmojiPage({super.key});

  @override
  State<ShowcaseEmojiPage> createState() => ShowcaseEmojiPageState();
}

class ShowcaseEmojiPageState extends State<ShowcaseEmojiPage> {
  String selectedEmoji1 = '😀';
  String selectedEmoji2 = '🐱';
  String selectedEmoji3 = '🌟';

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(NeoFadeSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Emoji Pickers', style: theme.typography.headlineMedium),
          const SizedBox(height: NeoFadeSpacing.lg),

          // Circle Animation Picker
          Text('NeoEmojiAvatarPicker', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'Tap the avatar - emojis pop out in a circle with elastic animation. Type custom emoji at bottom.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          Center(
            child: NeoEmojiAvatarPicker(
              selectedEmoji: selectedEmoji1,
              onEmojiSelected: (emoji) => setState(() => selectedEmoji1 = emoji),
            ),
          ),
          const SizedBox(height: NeoFadeSpacing.xl),

          // Grid Picker
          Text('NeoEmojiAvatarPickerGrid', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'Tap the avatar - shows a glass popup grid below. Better for compact layouts.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          Center(
            child: NeoEmojiAvatarPickerGrid(
              selectedEmoji: selectedEmoji2,
              onEmojiSelected: (emoji) => setState(() => selectedEmoji2 = emoji),
            ),
          ),
          const SizedBox(height: NeoFadeSpacing.xl),

          // Spiral Picker
          Text('NeoEmojiAvatarPickerSpiral', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.xs),
          Text(
            'Extra playful! Emojis spiral outward with staggered timing.',
            style: theme.typography.bodySmall,
          ),
          const SizedBox(height: NeoFadeSpacing.md),
          Center(
            child: NeoEmojiAvatarPickerSpiral(
              selectedEmoji: selectedEmoji3,
              onEmojiSelected: (emoji) => setState(() => selectedEmoji3 = emoji),
            ),
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),

          // Selected emojis summary
          NeoCard.topBorder(
            padding: const EdgeInsets.all(NeoFadeSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selected Emojis', style: theme.typography.titleSmall),
                const SizedBox(height: NeoFadeSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildSelectedDisplay('Circle', selectedEmoji1, theme),
                    buildSelectedDisplay('Grid', selectedEmoji2, theme),
                    buildSelectedDisplay('Spiral', selectedEmoji3, theme),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),
        ],
      ),
    );
  }

  Widget buildSelectedDisplay(String label, String emoji, NeoFadeThemeData theme) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: NeoFadeSpacing.xs),
        Text(label, style: theme.typography.labelSmall),
      ],
    );
  }
}
