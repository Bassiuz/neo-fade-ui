import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_emoji_avatar_picker.dart';

/// Emoji avatar picker with spiral animation - emojis spiral out with staggered timing.
/// Uses inner and outer circles to prevent overlap.
class NeoEmojiAvatarPickerSpiral extends StatefulWidget {
  final String? selectedEmoji;
  final ValueChanged<String> onEmojiSelected;
  final List<String>? emojis;
  final double? avatarSize;
  final double? emojiSize;
  final double? innerCircleRadius;
  final double? outerCircleRadius;
  final Duration? animationDuration;
  final Duration? staggerDelay;

  const NeoEmojiAvatarPickerSpiral({
    super.key,
    this.selectedEmoji,
    required this.onEmojiSelected,
    this.emojis,
    this.avatarSize,
    this.emojiSize,
    this.innerCircleRadius,
    this.outerCircleRadius,
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
  double get effectiveEmojiSize => widget.emojiSize ?? 28.0;
  double get effectiveInnerRadius => widget.innerCircleRadius ?? 70.0;
  double get effectiveOuterRadius => widget.outerCircleRadius ?? 115.0;
  Duration get effectiveStaggerDelay =>
      widget.staggerDelay ?? const Duration(milliseconds: 25);

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
    _setupAnimations();
  }

  void _setupAnimations() {
    final totalEmojis = effectiveEmojis.length;
    final totalStaggerTime = effectiveStaggerDelay.inMilliseconds * totalEmojis;
    final baseDuration =
        (widget.animationDuration ?? const Duration(milliseconds: 350))
            .inMilliseconds;
    final totalDuration =
        Duration(milliseconds: baseDuration + totalStaggerTime);

    _controller = AnimationController(
      duration: totalDuration,
      vsync: this,
    );

    // Create staggered animations for each emoji
    _itemAnimations.clear();
    for (int i = 0; i < totalEmojis; i++) {
      final startTime = (effectiveStaggerDelay.inMilliseconds * i) /
          totalDuration.inMilliseconds;
      final endTime =
          (effectiveStaggerDelay.inMilliseconds * i + baseDuration) /
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
    setState(() => _isExpanded = false);
    _controller.reverse();
    widget.onEmojiSelected(emoji);
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final totalSize = effectiveOuterRadius * 2 + effectiveEmojiSize + 20;

    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Inner circle emojis (first half, indices 0 to innerEmojis.length-1)
          ...innerEmojis.asMap().entries.map((entry) {
            final index = entry.key;
            final emoji = entry.value;
            final angle =
                (2 * math.pi * index / innerEmojis.length) - math.pi / 2;
            final spiralOffset = (index / innerEmojis.length) * 0.4;

            return _buildSpiralItem(
              emoji: emoji,
              animationIndex: index,
              angle: angle,
              spiralOffset: spiralOffset,
              radius: effectiveInnerRadius,
              colors: colors,
            );
          }),

          // Outer circle emojis (second half, indices continue from inner)
          ...outerEmojis.asMap().entries.map((entry) {
            final index = entry.key;
            final emoji = entry.value;
            final angle =
                (2 * math.pi * index / outerEmojis.length) - math.pi / 2;
            final spiralOffset = (index / outerEmojis.length) * 0.4;
            // Animation index continues from inner circle
            final animationIndex = innerEmojis.length + index;

            return _buildSpiralItem(
              emoji: emoji,
              animationIndex: animationIndex,
              angle: angle,
              spiralOffset: spiralOffset,
              radius: effectiveOuterRadius,
              colors: colors,
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

  Widget _buildSpiralItem({
    required String emoji,
    required int animationIndex,
    required double angle,
    required double spiralOffset,
    required double radius,
    required dynamic colors,
  }) {
    return AnimatedBuilder(
      animation: _itemAnimations[animationIndex],
      builder: (context, child) {
        final progress = _itemAnimations[animationIndex].value;
        final distance = radius * progress;
        // Spiral rotation effect
        final currentAngle = angle + (1 - progress) * spiralOffset * math.pi;
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
