import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/neo_fade_theme.dart';

/// An emoji avatar picker that reveals emojis in inner and outer circles on tap.
///
/// When expanded:
/// - Tap an emoji to select it
/// - Tap the center avatar again to open keyboard for custom emoji input
class NeoEmojiAvatarPicker extends StatefulWidget {
  final String? selectedEmoji;
  final ValueChanged<String> onEmojiSelected;
  final List<String>? emojis;
  final double? avatarSize;
  final double? emojiSize;
  final double? innerCircleRadius;
  final double? outerCircleRadius;
  final Duration? animationDuration;
  final bool allowCustomEmoji;

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
    this.innerCircleRadius,
    this.outerCircleRadius,
    this.animationDuration,
    this.allowCustomEmoji = true,
  });

  @override
  State<NeoEmojiAvatarPicker> createState() => NeoEmojiAvatarPickerState();
}

class NeoEmojiAvatarPickerState extends State<NeoEmojiAvatarPicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;
  bool _isTypingCustom = false;
  final TextEditingController _customEmojiController = TextEditingController();
  final FocusNode _customEmojiFocusNode = FocusNode();

  List<String> get effectiveEmojis =>
      widget.emojis ?? NeoEmojiAvatarPicker.defaultEmojis;
  double get effectiveAvatarSize => widget.avatarSize ?? 64.0;
  double get effectiveEmojiSize => widget.emojiSize ?? 28.0;
  double get effectiveInnerRadius => widget.innerCircleRadius ?? 70.0;
  double get effectiveOuterRadius => widget.outerCircleRadius ?? 115.0;

  // Split emojis into inner and outer circles
  List<String> get innerEmojis {
    final count = (effectiveEmojis.length / 2).floor();
    return effectiveEmojis.take(count).toList();
  }

  List<String> get outerEmojis {
    final count = (effectiveEmojis.length / 2).floor();
    return effectiveEmojis.skip(count).toList();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 500),
      vsync: this,
    );

    _customEmojiFocusNode.addListener(_onFocusChange);
    _customEmojiController.addListener(_onTextChange);
  }

  void _onFocusChange() {
    if (!_customEmojiFocusNode.hasFocus && _isTypingCustom) {
      setState(() => _isTypingCustom = false);
    }
  }

  void _onTextChange() {
    final text = _customEmojiController.text;
    if (text.isNotEmpty) {
      // Take only the first emoji/character and select it
      final firstChar = text.characters.first;
      _customEmojiController.clear();
      _selectEmoji(firstChar);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _customEmojiFocusNode.removeListener(_onFocusChange);
    _customEmojiController.removeListener(_onTextChange);
    _customEmojiController.dispose();
    _customEmojiFocusNode.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    if (_isExpanded && widget.allowCustomEmoji) {
      // Already expanded - trigger keyboard for custom emoji
      setState(() => _isTypingCustom = true);
      _customEmojiFocusNode.requestFocus();
    } else {
      setState(() {
        _isExpanded = !_isExpanded;
        _isTypingCustom = false;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse();
          _customEmojiFocusNode.unfocus();
        }
      });
    }
  }

  void _selectEmoji(String emoji) {
    // Close keyboard immediately
    _customEmojiFocusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();

    // Close picker
    setState(() {
      _isExpanded = false;
      _isTypingCustom = false;
    });
    _controller.reverse();

    // Notify selection
    widget.onEmojiSelected(emoji);
  }

  void _collapse() {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
        _isTypingCustom = false;
      });
      _controller.reverse();
      _customEmojiFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final totalSize = effectiveOuterRadius * 2 + effectiveEmojiSize + 20;

    return GestureDetector(
      onTap: _isExpanded ? _collapse : null,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: totalSize,
        height: totalSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Hidden text field for custom emoji input
          if (widget.allowCustomEmoji)
            Opacity(
              opacity: 0,
              child: SizedBox(
                width: 1,
                height: 1,
                child: TextField(
                  controller: _customEmojiController,
                  focusNode: _customEmojiFocusNode,
                  autofocus: false,
                  showCursor: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),

          // Outer circle emojis
          ...outerEmojis.asMap().entries.map((entry) {
            final index = entry.key;
            final emoji = entry.value;
            final angle =
                (2 * math.pi * index / outerEmojis.length) - math.pi / 2;

            return _buildEmojiItem(
              emoji: emoji,
              angle: angle,
              radius: effectiveOuterRadius,
              colors: colors,
            );
          }),

          // Inner circle emojis
          ...innerEmojis.asMap().entries.map((entry) {
            final index = entry.key;
            final emoji = entry.value;
            final angle =
                (2 * math.pi * index / innerEmojis.length) - math.pi / 2;

            return _buildEmojiItem(
              emoji: emoji,
              angle: angle,
              radius: effectiveInnerRadius,
              colors: colors,
            );
          }),

          // Center avatar (tap to expand, tap again to type custom)
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
                child: _isTypingCustom
                    ? Icon(
                        Icons.keyboard,
                        size: effectiveAvatarSize * 0.4,
                        color: colors.onPrimary,
                      )
                    : Text(
                        widget.selectedEmoji ?? '😀',
                        style: TextStyle(fontSize: effectiveAvatarSize * 0.5),
                      ),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiItem({
    required String emoji,
    required double angle,
    required double radius,
    required dynamic colors,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = Curves.elasticOut.transform(
          (_controller.value).clamp(0.0, 1.0),
        );
        final distance = radius * progress;
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
          width: effectiveEmojiSize + 10,
          height: effectiveEmojiSize + 10,
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
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              emoji,
              style: TextStyle(fontSize: effectiveEmojiSize * 0.6),
            ),
          ),
        ),
      ),
    );
  }
}
