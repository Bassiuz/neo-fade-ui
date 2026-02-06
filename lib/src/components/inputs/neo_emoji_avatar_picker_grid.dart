import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_emoji_avatar_picker.dart';

/// Emoji avatar picker that shows a grid popup on tap.
class NeoEmojiAvatarPickerGrid extends StatefulWidget {
  final String? selectedEmoji;
  final ValueChanged<String> onEmojiSelected;
  final List<String>? emojis;
  final double? avatarSize;
  final double? emojiSize;
  final int? columns;
  final Duration? animationDuration;

  const NeoEmojiAvatarPickerGrid({
    super.key,
    this.selectedEmoji,
    required this.onEmojiSelected,
    this.emojis,
    this.avatarSize,
    this.emojiSize,
    this.columns,
    this.animationDuration,
  });

  @override
  State<NeoEmojiAvatarPickerGrid> createState() =>
      NeoEmojiAvatarPickerGridState();
}

class NeoEmojiAvatarPickerGridState extends State<NeoEmojiAvatarPickerGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isExpanded = false;

  List<String> get effectiveEmojis =>
      widget.emojis ?? NeoEmojiAvatarPicker.defaultEmojis;
  double get effectiveAvatarSize => widget.avatarSize ?? 64.0;
  double get effectiveEmojiSize => widget.emojiSize ?? 36.0;
  int get effectiveColumns => widget.columns ?? 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 250),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
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

  void _collapse() {
    if (_isExpanded) {
      setState(() => _isExpanded = false);
      _controller.reverse();
    }
  }

  void _selectEmoji(String emoji) {
    widget.onEmojiSelected(emoji);
    _toggleExpand();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final gridWidth =
        (effectiveEmojiSize + 16) * effectiveColumns + NeoFadeSpacing.md * 2;

    return GestureDetector(
      onTap: _isExpanded ? _collapse : null,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar
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

        const SizedBox(height: NeoFadeSpacing.sm),

        // Grid popup
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            if (_controller.value == 0) return const SizedBox.shrink();

            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                alignment: Alignment.topCenter,
                child: child,
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
              child: Container(
                width: gridWidth,
                padding: const EdgeInsets.all(NeoFadeSpacing.md),
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: glass.tintOpacity + 0.1),
                  borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
                  border: Border.all(
                    color: colors.border.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Wrap(
                  spacing: NeoFadeSpacing.xs,
                  runSpacing: NeoFadeSpacing.xs,
                  children: effectiveEmojis.map((emoji) {
                    final isSelected = emoji == widget.selectedEmoji;
                    return GestureDetector(
                      onTap: () => _selectEmoji(emoji),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: effectiveEmojiSize + 12,
                        height: effectiveEmojiSize + 12,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.primary.withValues(alpha: 0.2)
                              : colors.surface.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(NeoFadeRadii.sm),
                          border: isSelected
                              ? Border.all(color: colors.primary, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: TextStyle(fontSize: effectiveEmojiSize * 0.7),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }
}
