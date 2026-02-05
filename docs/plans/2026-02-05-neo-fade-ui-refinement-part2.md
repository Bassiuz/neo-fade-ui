# Neo Fade UI Refinement Part 2 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Fix UI issues, add animation toggles, expand component browser with Material components, add golden tests, ensure full parameter customization, and add typography showcase.

**Architecture:** Fix existing components (CTA position, number selector icons), add toggleable animations, expand the component browser with new showcase pages (Display, Layout, Feedback, Typography), then add golden tests for all components.

**Tech Stack:** Flutter, Dart, Golden Tests (flutter_test)

---

### Task 1: Lower CTA Button Position in NeoBottomNavCTA

**Files:**
- Modify: `lib/src/components/navigation/neo_bottom_nav_cta.dart`

**Step 1: Adjust CTA positioning**

Change line 50-51 to lower the button (less overlap/stick-out):
```dart
const ctaOverlap = 8.0; // Changed from 20.0 - less overlap means lower position
```

Also adjust line 116 positioning formula:
```dart
bottom: 80 - ctaOverlap - ctaSize / 2 + 12, // Add offset to lower it
```

**Step 2: Commit**

```bash
git add lib/src/components/navigation/neo_bottom_nav_cta.dart
git commit -m "fix(nav): lower CTA button position in NeoBottomNavCTA"
```

---

### Task 2: Add Animation Toggle to NeoNavCTAButton

**Files:**
- Modify: `lib/src/components/navigation/neo_nav_cta_button.dart`
- Modify: `lib/src/components/navigation/neo_bottom_nav_cta.dart`

**Step 1: Add animated parameter to NeoNavCTAButton**

Add parameter after `borderRadius`:
```dart
final bool animated;

const NeoNavCTAButton({
  // ... existing params
  this.animated = true,
});
```

**Step 2: Conditionally start animation**

In initState, wrap the repeat call:
```dart
if (widget.animated) {
  _floatController.repeat(reverse: true);
}
```

In build, skip float offset if not animated:
```dart
Transform.translate(
  offset: Offset(0, widget.animated ? -_floatAnimation.value : 0),
  // ...
)
```

**Step 3: Add animated parameter to NeoBottomNavCTA**

Add to NeoBottomNavCTA:
```dart
final bool animated;

const NeoBottomNavCTA({
  // ... existing params
  this.animated = true,
});
```

Pass to NeoNavCTAButton:
```dart
NeoNavCTAButton(
  // ... existing params
  animated: animated,
)
```

**Step 4: Commit**

```bash
git add lib/src/components/navigation/neo_nav_cta_button.dart lib/src/components/navigation/neo_bottom_nav_cta.dart
git commit -m "feat(nav): add animated parameter to NeoBottomNavCTA"
```

---

### Task 3: Add Animation Toggle Demo to Navigation Showcase

**Files:**
- Modify: `lib/src/showcase/showcase_navigation_page.dart`

**Step 1: Add state variable**

```dart
bool ctaAnimated = true;
```

**Step 2: Add toggle switch before preview**

Add a row with a switch to toggle animation:
```dart
Row(
  children: [
    Text('Animation', style: theme.typography.labelMedium),
    const Spacer(),
    NeoSwitch2(
      value: ctaAnimated,
      onChanged: (v) => setState(() => ctaAnimated = v),
    ),
  ],
),
const SizedBox(height: NeoFadeSpacing.md),
```

**Step 3: Pass animated to NeoBottomNavCTA**

```dart
NeoBottomNavCTA(
  // ... existing params
  animated: ctaAnimated,
)
```

**Step 4: Commit**

```bash
git add lib/src/showcase/showcase_navigation_page.dart
git commit -m "feat(showcase): add animation toggle to navigation page"
```

---

### Task 4: Fix NeoNumberSelector1 - Extract Private Class and Verify Icons

**Files:**
- Create: `lib/src/components/inputs/neo_number_step_button.dart`
- Modify: `lib/src/components/inputs/neo_number_selector_1.dart`
- Modify: `lib/neo_fade_ui.dart`

**Step 1: Create NeoNumberStepButton in separate file**

Move `_StepButton` to its own file as `NeoNumberStepButton`, but change icon parameter to allow IconData to be passed in (and default to the proper plus/minus).

```dart
import 'package:flutter/widgets.dart';
import '../../theme/neo_fade_colors.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../utils/animation_utils.dart';

/// Step button for number selectors with press animation.
class NeoNumberStepButton extends StatefulWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;
  final NeoFadeColors colors;
  final bool isPrimary;

  const NeoNumberStepButton({
    super.key,
    required this.icon,
    required this.enabled,
    required this.onPressed,
    required this.colors,
    this.isPrimary = false,
  });

  @override
  State<NeoNumberStepButton> createState() => NeoNumberStepButtonState();
}

class NeoNumberStepButtonState extends State<NeoNumberStepButton>
    with SingleTickerProviderStateMixin {
  // ... (same implementation as _StepButtonState)
}
```

**Step 2: Update NeoNumberSelector1**

Replace `_StepButton` usage with `NeoNumberStepButton`, use explicit Icons.remove and Icons.add:
```dart
NeoNumberStepButton(
  icon: Icons.remove, // Clear minus icon
  enabled: canDecrement,
  onPressed: () => onChanged(value - step),
  colors: colors,
),
// ...
NeoNumberStepButton(
  icon: Icons.add, // Clear plus icon
  enabled: canIncrement,
  onPressed: () => onChanged(value + step),
  colors: colors,
  isPrimary: true,
),
```

**Step 3: Add export**

```dart
export 'src/components/inputs/neo_number_step_button.dart';
```

**Step 4: Commit**

```bash
git add lib/src/components/inputs/neo_number_step_button.dart lib/src/components/inputs/neo_number_selector_1.dart lib/neo_fade_ui.dart
git commit -m "refactor(inputs): extract NeoNumberStepButton, use clear plus/minus icons"
```

---

### Task 5: Add Display Showcase Page (Badges, Chips, Avatar, ListTile)

**Files:**
- Create: `lib/src/showcase/showcase_display_page.dart`
- Modify: `lib/src/showcase/component_browser_home.dart`

**Step 1: Create ShowcaseDisplayPage**

```dart
import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// Display components showcase page.
class ShowcaseDisplayPage extends StatefulWidget {
  const ShowcaseDisplayPage({super.key});

  @override
  State<ShowcaseDisplayPage> createState() => ShowcaseDisplayPageState();
}

class ShowcaseDisplayPageState extends State<ShowcaseDisplayPage> {
  bool chipSelected = false;

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(NeoFadeSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Display', style: theme.typography.headlineMedium),
          const SizedBox(height: NeoFadeSpacing.lg),

          // NeoBadge section
          Text('NeoBadge', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.md),
          Row(
            children: [
              NeoBadge(count: 5, child: Icon(Icons.notifications, size: 32)),
              const SizedBox(width: NeoFadeSpacing.lg),
              NeoBadge(count: 99, child: Icon(Icons.mail, size: 32)),
              const SizedBox(width: NeoFadeSpacing.lg),
              NeoBadge(showDot: true, child: Icon(Icons.chat, size: 32)),
            ],
          ),
          const SizedBox(height: NeoFadeSpacing.xl),

          // NeoChip section
          Text('NeoChip', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.md),
          Wrap(
            spacing: NeoFadeSpacing.sm,
            runSpacing: NeoFadeSpacing.sm,
            children: [
              NeoChip(label: 'Default'),
              NeoChip(label: 'Selected', selected: true),
              NeoChip(label: 'With Icon', icon: Icons.star),
              NeoChip(
                label: 'Deletable',
                onDeleted: () {},
              ),
            ],
          ),
          const SizedBox(height: NeoFadeSpacing.xl),

          // NeoAvatar section
          Text('NeoAvatar', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.md),
          Row(
            children: [
              NeoAvatar(initials: 'JD'),
              const SizedBox(width: NeoFadeSpacing.md),
              NeoAvatar(icon: Icons.person),
              const SizedBox(width: NeoFadeSpacing.md),
              NeoAvatar(initials: 'AB', size: 48),
            ],
          ),
          const SizedBox(height: NeoFadeSpacing.xl),

          // NeoListTile section
          Text('NeoListTile', style: theme.typography.titleMedium),
          const SizedBox(height: NeoFadeSpacing.md),
          NeoListTile(
            leading: NeoAvatar(initials: 'JD', size: 40),
            title: 'John Doe',
            subtitle: 'johndoe@example.com',
            trailing: Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const SizedBox(height: NeoFadeSpacing.sm),
          NeoListTile(
            leading: Icon(Icons.settings, size: 24),
            title: 'Settings',
            onTap: () {},
          ),

          const SizedBox(height: NeoFadeSpacing.xxl),
        ],
      ),
    );
  }
}
```

**Step 2: Add to categories in ComponentBrowserHome**

Add new category and page to the IndexedStack.

**Step 3: Commit**

```bash
git add lib/src/showcase/showcase_display_page.dart lib/src/showcase/component_browser_home.dart
git commit -m "feat(showcase): add display page with badges, chips, avatars, list tiles"
```

---

### Task 6: Add Layout Showcase Page (AppBar, Divider)

**Files:**
- Create: `lib/src/showcase/showcase_layout_page.dart`
- Modify: `lib/src/showcase/component_browser_home.dart`

**Step 1: Create ShowcaseLayoutPage**

Show NeoAppBar and NeoDivider variants.

**Step 2: Add to browser categories**

**Step 3: Commit**

```bash
git add lib/src/showcase/showcase_layout_page.dart lib/src/showcase/component_browser_home.dart
git commit -m "feat(showcase): add layout page with app bar and dividers"
```

---

### Task 7: Add Feedback Showcase Page (Snackbar, Dialog, Tooltip, Progress)

**Files:**
- Create: `lib/src/showcase/showcase_feedback_page.dart`
- Modify: `lib/src/showcase/component_browser_home.dart`

**Step 1: Create ShowcaseFeedbackPage**

Show buttons that trigger NeoSnackbar, NeoDialog, wrap items in NeoTooltip, and show NeoProgressIndicator (linear and circular).

**Step 2: Add to browser categories**

**Step 3: Commit**

```bash
git add lib/src/showcase/showcase_feedback_page.dart lib/src/showcase/component_browser_home.dart
git commit -m "feat(showcase): add feedback page with snackbar, dialog, tooltip, progress"
```

---

### Task 8: Add Typography Showcase Page

**Files:**
- Create: `lib/src/showcase/showcase_typography_page.dart`
- Modify: `lib/src/showcase/component_browser_home.dart`

**Step 1: Create ShowcaseTypographyPage**

```dart
import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// Typography showcase page.
class ShowcaseTypographyPage extends StatelessWidget {
  const ShowcaseTypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final typography = theme.typography;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(NeoFadeSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Typography', style: typography.headlineMedium),
          const SizedBox(height: NeoFadeSpacing.lg),

          _buildTypographyItem('Display Large', typography.displayLarge),
          _buildTypographyItem('Display Medium', typography.displayMedium),
          _buildTypographyItem('Display Small', typography.displaySmall),
          const SizedBox(height: NeoFadeSpacing.md),

          _buildTypographyItem('Headline Large', typography.headlineLarge),
          _buildTypographyItem('Headline Medium', typography.headlineMedium),
          _buildTypographyItem('Headline Small', typography.headlineSmall),
          const SizedBox(height: NeoFadeSpacing.md),

          _buildTypographyItem('Title Large', typography.titleLarge),
          _buildTypographyItem('Title Medium', typography.titleMedium),
          _buildTypographyItem('Title Small', typography.titleSmall),
          const SizedBox(height: NeoFadeSpacing.md),

          _buildTypographyItem('Body Large', typography.bodyLarge),
          _buildTypographyItem('Body Medium', typography.bodyMedium),
          _buildTypographyItem('Body Small', typography.bodySmall),
          const SizedBox(height: NeoFadeSpacing.md),

          _buildTypographyItem('Label Large', typography.labelLarge),
          _buildTypographyItem('Label Medium', typography.labelMedium),
          _buildTypographyItem('Label Small', typography.labelSmall),

          const SizedBox(height: NeoFadeSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildTypographyItem(String name, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: NeoFadeSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: style),
          Text(
            '${style.fontFamily} • ${style.fontSize?.toInt()}px • ${style.fontWeight}',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
```

**Step 2: Add to browser - new category "Typography"**

**Step 3: Commit**

```bash
git add lib/src/showcase/showcase_typography_page.dart lib/src/showcase/component_browser_home.dart
git commit -m "feat(showcase): add typography page showing all text styles"
```

---

### Task 9: Make Component Parameters Fully Overridable

**Files:**
- Review and update all Neo* components

**Step 1: Audit key components**

Ensure these components have all visual properties as optional parameters with sensible defaults:
- NeoButton1/2: size, padding, borderRadius, colors
- NeoCard1: padding, borderRadius, borderWidth, borderGradient
- NeoTextField2: padding, borderRadius, hintStyle
- NeoSlider: trackHeight, thumbSize, colors
- NeoBottomNavCTA: height, ctaSize, borderRadius, animated
- NeoSegmentedControl1/Icons: padding, borderRadius, indicatorColor

**Step 2: Add missing parameters to each component**

For each component, add optional parameters that fall back to theme values.

Example pattern:
```dart
final double? borderRadius;
// ...
final effectiveBorderRadius = borderRadius ?? NeoFadeRadii.md;
```

**Step 3: Commit**

```bash
git add lib/src/components/
git commit -m "feat(components): add full parameter customization to all components"
```

---

### Task 10: Set Up Golden Test Infrastructure

**Files:**
- Create: `test/golden_test.dart`
- Create: `test/helpers/golden_test_helpers.dart`
- Update: `pubspec.yaml` (add flutter_test if needed)

**Step 1: Create golden test helpers**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

/// Wraps a widget in NeoFadeTheme for golden testing.
Widget goldenTestWrapper(Widget child, {bool isDark = false}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NeoFadeTheme(
      data: isDark ? NeoFadeThemeData.dark() : NeoFadeThemeData.light(),
      child: Scaffold(
        body: Center(child: child),
      ),
    ),
  );
}
```

**Step 2: Create initial golden test file**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import 'helpers/golden_test_helpers.dart';

void main() {
  group('Button Goldens', () {
    testWidgets('NeoButton1 default', (tester) async {
      await tester.pumpWidget(goldenTestWrapper(
        NeoButton1(label: 'Button', onPressed: () {}),
      ));
      await expectLater(
        find.byType(NeoButton1),
        matchesGoldenFile('goldens/neo_button_1_default.png'),
      );
    });

    testWidgets('NeoButton1 disabled', (tester) async {
      await tester.pumpWidget(goldenTestWrapper(
        NeoButton1(label: 'Button', onPressed: null),
      ));
      await expectLater(
        find.byType(NeoButton1),
        matchesGoldenFile('goldens/neo_button_1_disabled.png'),
      );
    });
  });
}
```

**Step 3: Commit**

```bash
mkdir -p test/helpers test/goldens
git add test/ pubspec.yaml
git commit -m "test: add golden test infrastructure"
```

---

### Task 11: Add Golden Tests for All Components

**Files:**
- Create: `test/goldens/buttons_golden_test.dart`
- Create: `test/goldens/inputs_golden_test.dart`
- Create: `test/goldens/cards_golden_test.dart`
- Create: `test/goldens/navigation_golden_test.dart`
- Create: `test/goldens/selectors_golden_test.dart`
- Create: `test/goldens/display_golden_test.dart`
- Create: `test/goldens/feedback_golden_test.dart`
- Create: `test/goldens/layout_golden_test.dart`

**Step 1: Create golden tests for each category**

Each test file should test:
- Default state
- All variants/states (selected, disabled, focused, etc.)
- Both light and dark themes

**Step 2: Generate golden files**

Run: `fvm flutter test --update-goldens`

**Step 3: Commit**

```bash
git add test/
git commit -m "test: add golden tests for all Neo Fade UI components"
```

---

## Summary of Deliverables

| Task | Type | Description |
|------|------|-------------|
| 1 | Fix | Lower CTA button position |
| 2 | Feature | Add animated parameter to NeoNavCTAButton |
| 3 | Feature | Add animation toggle to navigation showcase |
| 4 | Refactor | Extract NeoNumberStepButton, fix icons |
| 5 | Feature | Add Display showcase page |
| 6 | Feature | Add Layout showcase page |
| 7 | Feature | Add Feedback showcase page |
| 8 | Feature | Add Typography showcase page |
| 9 | Feature | Full parameter customization |
| 10 | Test | Golden test infrastructure |
| 11 | Test | Golden tests for all components |
