# Neo Fade UI Refinement Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Refine the Neo Fade UI component library based on user feedback - fix bugs, create new wrapper components, and improve selected components.

**Architecture:** Extract reusable animation wrappers, fix state management issues in text fields, and enhance navigation components with better animations and visual design.

**Tech Stack:** Flutter, Dart, Google Fonts (Source Sans 3)

---

### Task 1: Fix NeoTextField2 Hint Text Bug

**Files:**
- Modify: `lib/src/components/inputs/neo_text_field_2.dart:52-56, 141`

**Problem:** The hint text doesn't disappear when typing because the widget doesn't listen to controller text changes - it only checks `_controller.text.isEmpty` on build but never triggers a rebuild when text changes.

**Step 1: Add controller listener in initState**

In `initState()`, after line 56, add:
```dart
_controller.addListener(_handleTextChange);
```

**Step 2: Add _handleTextChange method**

After `_handleFocusChange()` method (around line 92), add:
```dart
void _handleTextChange() {
  setState(() {});
}
```

**Step 3: Remove controller listener in dispose**

In `dispose()`, before disposing controller, add:
```dart
_controller.removeListener(_handleTextChange);
```

**Step 4: Test manually**

Run: `./scripts/serve_web.sh`
Expected: Type in TextField2 - hint text should disappear

**Step 5: Commit**

```bash
git add lib/src/components/inputs/neo_text_field_2.dart
git commit -m "fix(text-field): hint text now disappears when typing in NeoTextField2"
```

---

### Task 2: Create NeoPulsingGlow Wrapper

**Files:**
- Create: `lib/src/components/effects/neo_pulsing_glow.dart`
- Modify: `lib/neo_fade_ui.dart` (add export)

**Step 1: Create the wrapper widget**

Create `lib/src/components/effects/neo_pulsing_glow.dart`:
```dart
import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';

/// A wrapper widget that adds a pulsing gradient glow effect around its child.
///
/// Use this to draw attention to any widget without modifying the widget itself.
class NeoPulsingGlow extends StatefulWidget {
  final Widget child;
  final Duration? pulseDuration;
  final double? maxGlowRadius;
  final double? glowOpacity;
  final BorderRadius? borderRadius;
  final bool enabled;

  const NeoPulsingGlow({
    super.key,
    required this.child,
    this.pulseDuration,
    this.maxGlowRadius,
    this.glowOpacity,
    this.borderRadius,
    this.enabled = true,
  });

  @override
  State<NeoPulsingGlow> createState() => NeoPulsingGlowState();
}

class NeoPulsingGlowState extends State<NeoPulsingGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.pulseDuration ?? const Duration(seconds: 2),
    );

    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.enabled) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(NeoPulsingGlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;

    final effectiveMaxGlowRadius = widget.maxGlowRadius ?? NeoFadeSpacing.lg;
    final effectiveGlowOpacity = widget.glowOpacity ?? 0.4;
    final effectiveBorderRadius = widget.borderRadius ?? BorderRadius.circular(NeoFadeSpacing.md);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final glowIntensity = _pulseAnimation.value;
        final blurRadius = effectiveMaxGlowRadius * glowIntensity;

        return Container(
          decoration: BoxDecoration(
            borderRadius: effectiveBorderRadius,
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: effectiveGlowOpacity * glowIntensity),
                blurRadius: blurRadius,
                spreadRadius: NeoFadeSpacing.xxs * glowIntensity,
              ),
              BoxShadow(
                color: colors.secondary.withValues(alpha: effectiveGlowOpacity * 0.8 * glowIntensity),
                blurRadius: blurRadius * 0.8,
                spreadRadius: NeoFadeSpacing.xxs * glowIntensity * 0.5,
              ),
              BoxShadow(
                color: colors.tertiary.withValues(alpha: effectiveGlowOpacity * 0.6 * glowIntensity),
                blurRadius: blurRadius * 0.6,
                spreadRadius: 0,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
```

**Step 2: Add export to neo_fade_ui.dart**

Add after the foundation exports:
```dart
// Components - Effects
export 'src/components/effects/neo_pulsing_glow.dart';
```

**Step 3: Test manually**

Run: `./scripts/serve_web.sh`
Wrap any widget with `NeoPulsingGlow(child: ...)` in main.dart to verify

**Step 4: Commit**

```bash
git add lib/src/components/effects/neo_pulsing_glow.dart lib/neo_fade_ui.dart
git commit -m "feat(effects): add NeoPulsingGlow wrapper for attention effects"
```

---

### Task 3: Create Subtle NeoSlider

**Files:**
- Create: `lib/src/components/inputs/neo_slider.dart`
- Modify: `lib/neo_fade_ui.dart` (add export)

**Step 1: Create the subtle slider**

Create `lib/src/components/inputs/neo_slider.dart`:
```dart
import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// A subtle, minimal slider with a thin track and gradient active portion.
class NeoSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  const NeoSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  State<NeoSlider> createState() => NeoSliderState();
}

class NeoSliderState extends State<NeoSlider> {
  bool _isDragging = false;

  double get _normalizedValue =>
      ((widget.value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

  void _handleDragStart(DragStartDetails details) {
    setState(() => _isDragging = true);
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() => _isDragging = false);
  }

  void _handleDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    final newValue = (details.localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0);
    final mappedValue = widget.min + (newValue * (widget.max - widget.min));
    widget.onChanged(mappedValue);
  }

  void _handleTapDown(TapDownDetails details, BoxConstraints constraints) {
    final newValue = (details.localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0);
    final mappedValue = widget.min + (newValue * (widget.max - widget.min));
    widget.onChanged(mappedValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (details) => _handleTapDown(details, constraints),
          onHorizontalDragStart: _handleDragStart,
          onHorizontalDragEnd: _handleDragEnd,
          onHorizontalDragUpdate: (details) => _handleDragUpdate(details, constraints),
          child: Container(
            height: 32,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none,
              children: [
                // Track background
                Container(
                  height: 3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colors.border.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Active track with gradient
                AnimatedContainer(
                  duration: _isDragging ? Duration.zero : NeoFadeAnimations.fast,
                  height: 3,
                  width: constraints.maxWidth * _normalizedValue,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colors.primary, colors.secondary],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Thumb
                AnimatedPositioned(
                  duration: _isDragging ? Duration.zero : NeoFadeAnimations.fast,
                  left: (constraints.maxWidth * _normalizedValue) - 8,
                  child: AnimatedContainer(
                    duration: NeoFadeAnimations.fast,
                    width: _isDragging ? 20 : 16,
                    height: _isDragging ? 20 : 16,
                    decoration: BoxDecoration(
                      color: colors.onPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.primary,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: _isDragging ? 0.4 : 0.2),
                          blurRadius: _isDragging ? NeoFadeSpacing.sm : NeoFadeSpacing.xs,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

**Step 2: Add export to neo_fade_ui.dart**

Add to the inputs section:
```dart
export 'src/components/inputs/neo_slider.dart';
```

**Step 3: Commit**

```bash
git add lib/src/components/inputs/neo_slider.dart lib/neo_fade_ui.dart
git commit -m "feat(slider): add subtle NeoSlider with thin track and gradient"
```

---

### Task 4: Create Improved Bottom Nav with Rounded Square CTA

**Files:**
- Create: `lib/src/components/navigation/neo_bottom_nav_cta.dart`
- Modify: `lib/neo_fade_ui.dart` (add export)

**Step 1: Create the improved bottom nav**

Create `lib/src/components/navigation/neo_bottom_nav_cta.dart`:
```dart
import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_bottom_nav_1.dart';

/// Bottom navigation with an animated rounded-square CTA button that clips the nav bar.
class NeoBottomNavCTA extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<NeoBottomNavItem> items;
  final VoidCallback onCenterPressed;
  final IconData centerIcon;

  const NeoBottomNavCTA({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.items,
    required this.onCenterPressed,
    this.centerIcon = const IconData(0xe3af, fontFamily: 'MaterialIcons'),
  });

  @override
  State<NeoBottomNavCTA> createState() => NeoBottomNavCTAState();
}

class NeoBottomNavCTAState extends State<NeoBottomNavCTA>
    with SingleTickerProviderStateMixin {
  late AnimationController _idleController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: 4).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final leftItems = widget.items.take((widget.items.length / 2).floor()).toList();
    final rightItems = widget.items.skip((widget.items.length / 2).floor()).toList();

    return SizedBox(
      height: 90,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Nav bar with notch
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: NeoFadeSpacing.md,
                    vertical: NeoFadeSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: glass.tintOpacity + 0.15),
                    borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
                    border: Border.all(
                      color: colors.border.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...leftItems.asMap().entries.map((entry) =>
                          _buildNavItem(entry.key, entry.value, colors)),
                      const SizedBox(width: 64),
                      ...rightItems.asMap().entries.map((entry) =>
                          _buildNavItem(entry.key + leftItems.length, entry.value, colors)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Floating CTA button
          AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: 30 + _floatAnimation.value,
                child: child!,
              );
            },
            child: _CTAButton(
              icon: widget.centerIcon,
              onPressed: widget.onCenterPressed,
              colors: colors,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, NeoBottomNavItem item, dynamic colors) {
    final isSelected = index == widget.selectedIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onIndexChanged(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: NeoFadeAnimations.fast,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: NeoFadeAnimations.fast,
                padding: const EdgeInsets.all(NeoFadeSpacing.xs),
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary.withValues(alpha: 0.15) : null,
                  borderRadius: BorderRadius.circular(NeoFadeRadii.sm),
                ),
                child: Icon(
                  item.icon,
                  size: 24,
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                ),
              ),
              if (item.label != null) ...[
                const SizedBox(height: NeoFadeSpacing.xxs),
                Text(
                  item.label!,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? colors.primary : colors.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CTAButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final dynamic colors;

  const _CTAButton({
    required this.icon,
    required this.onPressed,
    required this.colors,
  });

  @override
  State<_CTAButton> createState() => _CTAButtonState();
}

class _CTAButtonState extends State<_CTAButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _pressController.reverse(),
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotateAnimation.value,
              child: child,
            ),
          );
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.colors.primary,
                widget.colors.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.colors.primary.withValues(alpha: 0.5),
                blurRadius: NeoFadeSpacing.md,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: widget.colors.secondary.withValues(alpha: 0.3),
                blurRadius: NeoFadeSpacing.lg,
                spreadRadius: 0,
              ),
            ],
            border: Border.all(
              color: const Color(0xFFFFFFFF).withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Icon(
            widget.icon,
            size: 28,
            color: widget.colors.onPrimary,
          ),
        ),
      ),
    );
  }
}
```

**Step 2: Add export to neo_fade_ui.dart**

Add to navigation section:
```dart
export 'src/components/navigation/neo_bottom_nav_cta.dart';
```

**Step 3: Commit**

```bash
git add lib/src/components/navigation/neo_bottom_nav_cta.dart lib/neo_fade_ui.dart
git commit -m "feat(nav): add NeoBottomNavCTA with animated rounded-square button"
```

---

### Task 5: Create Segmented Control with Icons Above Labels

**Files:**
- Create: `lib/src/components/selectors/neo_segmented_control_icons.dart`
- Modify: `lib/neo_fade_ui.dart` (add export)

**Step 1: Create the icon variant**

Create `lib/src/components/selectors/neo_segmented_control_icons.dart`:
```dart
import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_segmented_control_1.dart';

/// Glass segmented control with icons above labels and sliding gradient indicator.
class NeoSegmentedControlIcons<T> extends StatelessWidget {
  final T selectedValue;
  final ValueChanged<T> onValueChanged;
  final List<NeoSegment<T>> segments;

  const NeoSegmentedControlIcons({
    super.key,
    required this.selectedValue,
    required this.onValueChanged,
    required this.segments,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final selectedIndex = segments.indexWhere((s) => s.value == selectedValue);

    return ClipRRect(
      borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
        child: Container(
          padding: const EdgeInsets.all(NeoFadeSpacing.xs),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: glass.tintOpacity),
            borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
            border: Border.all(
              color: colors.border.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final segmentWidth = constraints.maxWidth / segments.length;
              return Stack(
                children: [
                  // Sliding indicator
                  AnimatedPositioned(
                    duration: NeoFadeAnimations.normal,
                    curve: NeoFadeAnimations.defaultCurve,
                    left: selectedIndex * segmentWidth,
                    top: 0,
                    bottom: 0,
                    width: segmentWidth,
                    child: Container(
                      margin: const EdgeInsets.all(NeoFadeSpacing.xxs),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colors.primary.withValues(alpha: 0.8),
                            colors.secondary.withValues(alpha: 0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(NeoFadeRadii.md),
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.3),
                            blurRadius: NeoFadeSpacing.sm,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Segments with icons above labels
                  Row(
                    children: segments.map((segment) {
                      final isSelected = segment.value == selectedValue;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => onValueChanged(segment.value),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: NeoFadeSpacing.sm,
                              horizontal: NeoFadeSpacing.xs,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (segment.icon != null) ...[
                                  AnimatedContainer(
                                    duration: NeoFadeAnimations.fast,
                                    child: Icon(
                                      segment.icon,
                                      size: 22,
                                      color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: NeoFadeSpacing.xs),
                                ],
                                Text(
                                  segment.label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    color: isSelected ? colors.onPrimary : colors.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
```

**Step 2: Add export to neo_fade_ui.dart**

Add to selectors section:
```dart
export 'src/components/selectors/neo_segmented_control_icons.dart';
```

**Step 3: Commit**

```bash
git add lib/src/components/selectors/neo_segmented_control_icons.dart lib/neo_fade_ui.dart
git commit -m "feat(selectors): add NeoSegmentedControlIcons with icons above labels"
```

---

### Task 6: Update Showcase in main.dart

**Files:**
- Modify: `lib/main.dart`

**Step 1: Add imports and update showcase sections**

Replace/update the showcase to only show selected components:
- Keep: NeoCard1, NeoTextField2, NeoCheckbox4, NeoSwitch2, NeoButton1, NeoButton2
- Add: NeoPulsingGlow demo, NeoSlider, NeoBottomNavCTA, NeoSegmentedControlIcons
- Remove: All slider variants except NeoSlider

**Step 2: Build and verify**

Run: `fvm flutter build web --release && ./scripts/serve_web.sh`
Expected: All new components visible and working

**Step 3: Commit**

```bash
git add lib/main.dart
git commit -m "chore(showcase): update main.dart with refined component selection"
```

---

### Task 7: Final Cleanup and Documentation

**Files:**
- Modify: `docs/ui-selection-summary.md`

**Step 1: Update documentation with final component list**

Update the summary with the refined components that made the cut.

**Step 2: Final commit**

```bash
git add docs/ui-selection-summary.md
git commit -m "docs: update component selection summary with final refined set"
```

---

### Task 8: Create Component Browser App

**Files:**
- Modify: `lib/main.dart` (complete rewrite as component browser)

**Step 1: Create a tabbed/categorized browser UI**

Replace main.dart with a proper component browser that has:
- Side navigation or tabs for categories: Buttons, Inputs, Cards, Navigation, Selectors, Effects
- Each category shows all variants of that component type
- Clean layout with labels and interactive demos

**Step 2: Design categories**

Categories to include:
- **Buttons**: NeoButton1 (gradient filled), NeoButton2 (gradient border)
- **Inputs**: NeoTextField2, NeoCheckbox4, NeoSwitch2, NeoSlider, NeoNumberSelector1
- **Cards**: NeoCard1, NeoFeatureCard1
- **Navigation**: NeoBottomNavCTA
- **Selectors**: NeoSegmentedControl1, NeoSegmentedControlIcons
- **Effects**: NeoPulsingGlow wrapper demo

**Step 3: Commit**

```bash
git add lib/main.dart
git commit -m "feat(app): create component browser with categorized navigation"
```

---

### Task 9: Create Material Design Components in Neo Fade Style

**Files:**
- Create new components based on Material Design patterns

**Components to create (all in Neo Fade glass + gradient style):**

**Buttons:**
- `NeoFAB` - Floating Action Button with gradient
- `NeoTextButton` - Text-only button with gradient underline on hover

**Inputs:**
- `NeoRadioButton` - Radio buttons with gradient fill
- `NeoDropdown` - Glass dropdown with gradient border
- `NeoSearchBar` - Search input with glass background

**Feedback:**
- `NeoSnackbar` - Glass snackbar with gradient accent
- `NeoDialog` - Glass dialog/modal
- `NeoTooltip` - Glass tooltip with gradient pointer
- `NeoProgressIndicator` - Linear/circular progress with gradient

**Data Display:**
- `NeoChip` - Glass chip with gradient border
- `NeoBadge` - Notification badge with gradient
- `NeoAvatar` - Avatar with gradient ring
- `NeoListTile` - List item with glass background

**Layout:**
- `NeoAppBar` - Glass app bar with gradient bottom border
- `NeoDivider` - Subtle gradient divider

Each component follows the style:
- Tinted glass background (BackdropFilter + surface color with opacity)
- Gradient accents on interaction (focus, hover, selection)
- Soft glow effects for emphasis
- Source Sans 3 typography

**Step-by-step:** Create each component in its own file, add export, add to browser.

---

## Summary of Deliverables

| Component | Type | Description |
|-----------|------|-------------|
| NeoTextField2 | Fix | Hint text now disappears when typing |
| NeoPulsingGlow | New | Wrapper for attention-grabbing pulsing glow |
| NeoSlider | New | Subtle, minimal slider with gradient track |
| NeoBottomNavCTA | New | Animated nav with rounded-square floating CTA |
| NeoSegmentedControlIcons | New | Segmented control with icons above labels |
