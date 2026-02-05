import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/neo_fade_theme.dart';

/// An emoji avatar picker that reveals emojis in a circle animation on tap.
class NeoEmojiAvatarPicker extends StatefulWidget {
  final String? selectedEmoji;
  final ValueChanged<String> onEmojiSelected;
  final List<String>? emojis;
  final double? avatarSize;
  final double? emojiSize;
  final double? circleRadius;
  final Duration? animationDuration;

  static const defaultEmojis = [
    '😀', '😎', '🥳', '😍', '🤔', '😴', '🤩', '😇',
    '🐱', '🐶', '🦊', '🐼', '🦄', '🐸', '🦋', '🐝',
    '🌟', '🔥', '🌈', '🎉', '💎', '🚀', '🎯', '🍕', '🎵',
  ];

  const NeoEmojiAvatarPicker({
    super.key,
    this.selectedEmoji,
    required this.onEmojiSelected,
    this.emojis,
    this.avatarSize,
    this.emojiSize,
    this.circleRadius,
    this.animationDuration,
  });

  @override
  State<NeoEmojiAvatarPicker> createState() => NeoEmojiAvatarPickerState();
}

class NeoEmojiAvatarPickerState extends State<NeoEmojiAvatarPicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;

  List<String> get effectiveEmojis =>
      widget.emojis ?? NeoEmojiAvatarPicker.defaultEmojis;
  double get effectiveAvatarSize => widget.avatarSize ?? 64.0;
  double get effectiveEmojiSize => widget.emojiSize ?? 32.0;
  double get effectiveCircleRadius => widget.circleRadius ?? 100.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _selectEmoji(String emoji) {
    widget.onEmojiSelected(emoji);
    _toggleExpand();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final totalSize = effectiveCircleRadius * 2 + effectiveEmojiSize + 20;

    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Emoji circle items
          ...effectiveEmojis.asMap().entries.map((entry) {
            final index = entry.key;
            final emoji = entry.value;
            // Distribute emojis evenly around the circle, starting from top
            final angle =
                (2 * math.pi * index / effectiveEmojis.length) - math.pi / 2;

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Elastic curve for bouncy feel
                final progress = Curves.elasticOut.transform(
                  (_controller.value).clamp(0.0, 1.0),
                );
                final distance = effectiveCircleRadius * progress;
                final x = math.cos(angle) * distance;
                final y = math.sin(angle) * distance;
                final scale = progress;
                final opacity = _controller.value.clamp(0.0, 1.0);

                return Transform.translate(
                  offset: Offset(x, y),
                  child: Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: child,
                    ),
                  ),
                );
              },
              child: GestureDetector(
                onTap: _isExpanded ? () => _selectEmoji(emoji) : null,
                child: Container(
                  width: effectiveEmojiSize + 12,
                  height: effectiveEmojiSize + 12,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.border.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.15),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: TextStyle(fontSize: effectiveEmojiSize * 0.65),
                    ),
                  ),
                ),
              ),
            );
          }),

          // Center avatar (tap to expand/collapse)
          GestureDetector(
            onTap: _toggleExpand,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: effectiveAvatarSize,
              height: effectiveAvatarSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colors.primary, colors.secondary],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.onPrimary.withValues(alpha: 0.3),
                  width: 3,
                ),
                boxShadow: _isExpanded
                    ? [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.4),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  widget.selectedEmoji ?? '😀',
                  style: TextStyle(fontSize: effectiveAvatarSize * 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
