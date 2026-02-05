# Neo Fade UI Part 3 - New Components Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Fix CTA button position, fix showcase scrolling, add liquid glass floating action bar, and create playful emoji avatar selector with circle animation.

**Architecture:** Fix existing components first, then create new NeoFloatingActions (liquid glass bottom bar) and NeoEmojiAvatarPicker (tap to reveal emojis in circle animation with multiple variants).

**Tech Stack:** Flutter, Dart, animations (AnimationController, TweenSequence)

---

### Task 1: Fix CTA Button Position - Lower to 10-15% Stick Out

**Files:**
- Modify: `lib/src/components/navigation/neo_bottom_nav_cta.dart`

**Problem:** Button sticks out too much. Currently `ctaOverlap` defaults to 8.0, but the positioning formula makes it float too high.

**Current formula (line 141):**
```dart
bottom: effectiveHeight - effectiveCtaOverlap - effectiveCtaSize / 2,
```

With height=80, ctaSize=56, ctaOverlap=8:
- bottom = 80 - 8 - 28 = 44 (button center is 44px from bottom, way too high)

**New approach:** Button should overlap the nav bar with only 10-15% (5.6-8.4px) sticking above.

Change the positioning to put the button's bottom edge at nav bar top, then lower it so only 10-15% sticks out:
```dart
// Position so only ~12% of button sticks above nav bar
final stickOutAmount = effectiveCtaSize * 0.12; // ~7px for 56px button
bottom: effectiveHeight - effectiveCtaSize + stickOutAmount,
```

With height=80, ctaSize=56, stickOutAmount=6.7:
- bottom = 80 - 56 + 6.7 = 30.7 (button bottom at 30.7, top at 86.7, only 6.7px above nav)

**Step 1: Update positioning formula**

Replace line 141:
```dart
// Position CTA so only ~12% sticks above the nav bar
final stickOutAmount = effectiveCtaSize * 0.12;
```

And update the Positioned bottom:
```dart
Positioned(
  bottom: effectiveHeight - effectiveCtaSize + stickOutAmount,
```

Also update the SizedBox height (line 77-78):
```dart
return SizedBox(
  height: effectiveHeight + stickOutAmount,
```

**Step 2: Commit**

```bash
git add lib/src/components/navigation/neo_bottom_nav_cta.dart
git commit -m "fix(nav): lower CTA button to only 12% stick out above nav bar"
```

---

### Task 2: Fix Navigation Showcase - Make Preview Horizontally Scrollable

**Files:**
- Modify: `lib/src/showcase/showcase_navigation_page.dart`

**Problem:** The bottom nav in the preview container can't be reached on narrow screens because it's not scrollable.

**Solution:** Wrap the NeoBottomNavCTA in a SingleChildScrollView with horizontal scrolling, or make the preview container wider with horizontal scroll.

**Step 1: Make the preview container scrollable**

Wrap the bottom nav Positioned content in a horizontal scroll:
```dart
Positioned(
  left: 0,
  right: 0,
  bottom: 0,
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: ConstrainedBox(
      constraints: BoxConstraints(minWidth: 400),
      child: NeoBottomNavCTA(
        // ... existing props
      ),
    ),
  ),
),
```

**Step 2: Commit**

```bash
git add lib/src/showcase/showcase_navigation_page.dart
git commit -m "fix(showcase): make navigation preview horizontally scrollable"
```

---

### Task 3: Create NeoFloatingActions - Liquid Glass Floating Bottom Bar

**Files:**
- Create: `lib/src/components/navigation/neo_floating_actions.dart`
- Create: `lib/src/components/navigation/neo_floating_action_item.dart`
- Modify: `lib/neo_fade_ui.dart` (add exports)

**Step 1: Create NeoFloatingActionItem data class**

```dart
import 'package:flutter/widgets.dart';

/// Data class for a floating action item.
class NeoFloatingActionItem {
  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;

  const NeoFloatingActionItem({
    required this.icon,
    this.label,
    this.onPressed,
  });
}
```

**Step 2: Create NeoFloatingActions widget**

A minimal liquid glass bar that floats at the bottom with small action buttons:

```dart
import 'dart:ui';
import 'package:flutter/widgets.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_floating_action_item.dart';

/// A liquid glass floating action bar with small action buttons.
class NeoFloatingActions extends StatelessWidget {
  final List<NeoFloatingActionItem> items;
  final double? height;
  final double? iconSize;
  final double? spacing;
  final double? borderRadius;
  final EdgeInsets? margin;

  const NeoFloatingActions({
    super.key,
    required this.items,
    this.height,
    this.iconSize,
    this.spacing,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final effectiveHeight = height ?? 56.0;
    final effectiveIconSize = iconSize ?? 22.0;
    final effectiveSpacing = spacing ?? NeoFadeSpacing.md;
    final effectiveBorderRadius = borderRadius ?? NeoFadeRadii.xl;
    final effectiveMargin = margin ?? const EdgeInsets.all(NeoFadeSpacing.md);

    return Padding(
      padding: effectiveMargin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: glass.blur * 1.5, sigmaY: glass.blur * 1.5),
          child: Container(
            height: effectiveHeight,
            padding: EdgeInsets.symmetric(horizontal: effectiveSpacing),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.surface.withValues(alpha: glass.tintOpacity + 0.1),
                  colors.surface.withValues(alpha: glass.tintOpacity + 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              border: Border.all(
                color: colors.border.withValues(alpha: 0.2),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : effectiveSpacing / 2,
                    right: index == items.length - 1 ? 0 : effectiveSpacing / 2,
                  ),
                  child: _FloatingActionButton(
                    item: item,
                    iconSize: effectiveIconSize,
                    colors: colors,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingActionButton extends StatefulWidget {
  // ... implementation with press animation
}
```

Note: Extract `_FloatingActionButton` to its own file `neo_floating_action_button.dart` to follow project rules (no private classes).

**Step 3: Add exports**

**Step 4: Commit**

```bash
git add lib/src/components/navigation/
git commit -m "feat(nav): add NeoFloatingActions liquid glass bottom bar"
```

---

### Task 4: Create NeoEmojiAvatarPicker - Base Component

**Files:**
- Create: `lib/src/components/inputs/neo_emoji_avatar_picker.dart`
- Create: `lib/src/components/inputs/neo_emoji_circle_item.dart`
- Modify: `lib/neo_fade_ui.dart` (add exports)

**Step 1: Create data structures and base widget**

Default emojis (mix of faces, creatures, fun things):
```dart
static const defaultEmojis = [
  '😀', '😎', '🥳', '😍', '🤔', '😴', '🤩', '😇', // Faces
  '🐱', '🐶', '🦊', '🐼', '🦄', '🐸', '🦋', '🐝', // Creatures
  '🌟', '🔥', '🌈', '🎉', '💎', '🚀', '🎯', '🍕', '🎵', // Fun things
];
```

**Step 2: Create the picker widget**

```dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/neo_fade_spacing.dart';
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
    this.circleRadius,
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

  List<String> get effectiveEmojis => widget.emojis ?? NeoEmojiAvatarPicker.defaultEmojis;
  double get effectiveAvatarSize => widget.avatarSize ?? 64.0;
  double get effectiveEmojiSize => widget.emojiSize ?? 32.0;
  double get effectiveCircleRadius => widget.circleRadius ?? 100.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 400),
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
    final totalSize = effectiveCircleRadius * 2 + effectiveEmojiSize;

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
            final angle = (2 * math.pi * index / effectiveEmojis.length) - math.pi / 2;

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final progress = Curves.elasticOut.transform(_controller.value);
                final distance = effectiveCircleRadius * progress;
                final x = math.cos(angle) * distance;
                final y = math.sin(angle) * distance;
                final scale = progress;
                final opacity = progress;

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
                onTap: () => _selectEmoji(emoji),
                child: Container(
                  width: effectiveEmojiSize + 8,
                  height: effectiveEmojiSize + 8,
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: TextStyle(fontSize: effectiveEmojiSize * 0.7),
                    ),
                  ),
                ),
              ),
            );
          }),

          // Center avatar (tap to expand)
          GestureDetector(
            onTap: _toggleExpand,
            child: Container(
              width: effectiveAvatarSize,
              height: effectiveAvatarSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.primary, colors.secondary],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.onPrimary.withValues(alpha: 0.3),
                  width: 3,
                ),
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
```

**Step 3: Add exports and commit**

```bash
git add lib/src/components/inputs/neo_emoji_avatar_picker.dart lib/neo_fade_ui.dart
git commit -m "feat(inputs): add NeoEmojiAvatarPicker with circle animation"
```

---

### Task 5: Create NeoEmojiAvatarPicker Variant 2 - Grid Popup

**Files:**
- Create: `lib/src/components/inputs/neo_emoji_avatar_picker_grid.dart`

**Step 1: Create grid variant**

Instead of circle, shows a grid popup below/above the avatar:

```dart
/// Emoji avatar picker that shows a grid popup on tap.
class NeoEmojiAvatarPickerGrid extends StatefulWidget {
  // Similar props to base picker
  // Shows a glass popup with emoji grid
  // Includes text field for custom emoji at bottom
}
```

**Step 2: Commit**

```bash
git add lib/src/components/inputs/neo_emoji_avatar_picker_grid.dart lib/neo_fade_ui.dart
git commit -m "feat(inputs): add NeoEmojiAvatarPickerGrid variant"
```

---

### Task 6: Create NeoEmojiAvatarPicker Variant 3 - Spiral Animation

**Files:**
- Create: `lib/src/components/inputs/neo_emoji_avatar_picker_spiral.dart`

**Step 1: Create spiral variant**

Emojis spiral outward with staggered timing for extra playfulness:

```dart
/// Emoji avatar picker with spiral animation - emojis spiral out with staggered timing.
class NeoEmojiAvatarPickerSpiral extends StatefulWidget {
  // Similar to base but with spiral animation
  // Each emoji has slight delay creating spiral effect
}
```

**Step 2: Commit**

```bash
git add lib/src/components/inputs/neo_emoji_avatar_picker_spiral.dart lib/neo_fade_ui.dart
git commit -m "feat(inputs): add NeoEmojiAvatarPickerSpiral variant"
```

---

### Task 7: Add Custom Emoji Input to Base Picker

**Files:**
- Modify: `lib/src/components/inputs/neo_emoji_avatar_picker.dart`

**Step 1: Add custom emoji text field option**

When `allowCustomEmoji` is true and picker is expanded, show a small text input at center-bottom to type custom emoji.

**Step 2: Commit**

```bash
git add lib/src/components/inputs/neo_emoji_avatar_picker.dart
git commit -m "feat(inputs): add custom emoji text input to picker"
```

---

### Task 8: Add Emoji Pickers to Showcase

**Files:**
- Create: `lib/src/showcase/showcase_emoji_page.dart`
- Modify: `lib/src/showcase/component_browser_home.dart`

**Step 1: Create showcase page**

Show all three emoji picker variants with interactive demos.

**Step 2: Add to browser categories**

**Step 3: Commit**

```bash
git add lib/src/showcase/showcase_emoji_page.dart lib/src/showcase/component_browser_home.dart
git commit -m "feat(showcase): add emoji picker showcase page"
```

---

### Task 9: Add NeoFloatingActions to Navigation Showcase

**Files:**
- Modify: `lib/src/showcase/showcase_navigation_page.dart`

**Step 1: Add section for NeoFloatingActions**

Show the liquid glass floating bar with sample actions.

**Step 2: Commit**

```bash
git add lib/src/showcase/showcase_navigation_page.dart
git commit -m "feat(showcase): add NeoFloatingActions to navigation page"
```

---

## Summary of Deliverables

| Task | Type | Description |
|------|------|-------------|
| 1 | Fix | Lower CTA button to 10-15% stick out |
| 2 | Fix | Make navigation showcase scrollable |
| 3 | Feature | NeoFloatingActions liquid glass bottom bar |
| 4 | Feature | NeoEmojiAvatarPicker with circle animation |
| 5 | Feature | NeoEmojiAvatarPickerGrid variant |
| 6 | Feature | NeoEmojiAvatarPickerSpiral variant |
| 7 | Feature | Custom emoji text input |
| 8 | Feature | Emoji picker showcase page |
| 9 | Feature | Add floating actions to showcase |
