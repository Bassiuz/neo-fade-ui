import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_emoji_avatar_picker.dart';

/// Emoji avatar picker with spiral animation - emojis spiral out with staggered timing.
class NeoEmojiAvatarPickerSpiral extends StatefulWidget {
  final String? selectedEmoji;
  final ValueChanged<String> onEmojiSelected;
  final List<String>? emojis;
  final double? avatarSize;
  final double? emojiSize;
  final double? circleRadius;
  final Duration? animationDuration;
  final Duration? staggerDelay;

  const NeoEmojiAvatarPickerSpiral({
    super.key,
    this.selectedEmoji,
    required this.onEmojiSelected,
    this.emojis,
    this.avatarSize,
    this.emojiSize,
    this.circleRadius,
    this.animationDuration,
    this.staggerDelay,
  });

  @override
  State<NeoEmojiAvatarPickerSpiral> createState() =>
      NeoEmojiAvatarPickerSpiralState();
}

class NeoEmojiAvatarPickerSpiralState extends State<NeoEmojiAvatarPickerSpiral>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Animation<double>> _itemAnimations = [];
  bool _isExpanded = false;

  List<String> get effectiveEmojis =>
      widget.emojis ?? NeoEmojiAvatarPicker.defaultEmojis;
  double get effectiveAvatarSize => widget.avatarSize ?? 64.0;
  double get effectiveEmojiSize => widget.emojiSize ?? 32.0;
  double get effectiveCircleRadius => widget.circleRadius ?? 100.0;
  Duration get effectiveStaggerDelay =>
      widget.staggerDelay ?? const Duration(milliseconds: 30);

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Total duration = base animation + (stagger * num items)
    final totalStaggerTime =
        effectiveStaggerDelay.inMilliseconds * effectiveEmojis.length;
    final baseDuration =
        (widget.animationDuration ?? const Duration(milliseconds: 400))
            .inMilliseconds;
    final totalDuration = Duration(milliseconds: baseDuration + totalStaggerTime);

    _controller = AnimationController(
      duration: totalDuration,
      vsync: this,
    );

    // Create staggered animations for each emoji
    _itemAnimations.clear();
    for (int i = 0; i < effectiveEmojis.length; i++) {
      final startTime = (effectiveStaggerDelay.inMilliseconds * i) /
          totalDuration.inMilliseconds;
      final endTime = (effectiveStaggerDelay.inMilliseconds * i + baseDuration) /
          totalDuration.inMilliseconds;

      _itemAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              startTime.clamp(0.0, 1.0),
              endTime.clamp(0.0, 1.0),
              curve: Curves.elasticOut,
            ),
          ),
        ),
      );
    }
  }

  @override
  void didUpdateWidget(NeoEmojiAvatarPickerSpiral oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.emojis?.length != oldWidget.emojis?.length ||
        widget.animationDuration != oldWidget.animationDuration ||
        widget.staggerDelay != oldWidget.staggerDelay) {
      _controller.dispose();
      _setupAnimations();
    }
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
          // Emoji spiral items
          ...effectiveEmojis.asMap().entries.map((entry) {
            final index = entry.key;
            final emoji = entry.value;
            // Spiral: angle increases with index for spiral effect
            final baseAngle =
                (2 * math.pi * index / effectiveEmojis.length) - math.pi / 2;
            // Add slight rotation offset based on index for spiral feel
            final spiralOffset = (index / effectiveEmojis.length) * 0.3;

            return AnimatedBuilder(
              animation: _itemAnimations[index],
              builder: (context, child) {
                final progress = _itemAnimations[index].value;
                final distance = effectiveCircleRadius * progress;
                // Spiral rotation: starts from inner angle and rotates outward
                final currentAngle =
                    baseAngle + (1 - progress) * spiralOffset * math.pi;
                final x = math.cos(currentAngle) * distance;
                final y = math.sin(currentAngle) * distance;
                final scale = progress;
                final opacity = progress.clamp(0.0, 1.0);

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

          // Center avatar
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
