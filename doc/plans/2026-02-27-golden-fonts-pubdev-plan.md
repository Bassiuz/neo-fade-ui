# Golden Font Fix & Pub.dev Readiness Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make golden tests render with the production font (SourceSans3) and prepare the package for pub.dev publishing with maximum pub points.

**Architecture:** Load SourceSans3 font in test config so all golden tests use the real font. Then add all missing pub.dev requirements: metadata, docs, example, changelog.

**Tech Stack:** Flutter, FVM, Dart dartdoc

---

### Task 1: Load SourceSans3 in test config

**Files:**
- Create: `test/flutter_test_config.dart`
- Modify: `test/helpers/golden_test_helpers.dart:20-22`

**Step 1: Create `test/flutter_test_config.dart`**

```dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final fontData = File('assets/fonts/SourceSans3-VariableFont.ttf').readAsBytesSync();
  final fontLoader = FontLoader('SourceSans3')
    ..addFont(Future.value(ByteData.sublistView(Uint8List.fromList(fontData))));
  await fontLoader.load();

  await testMain();
}
```

**Step 2: Update `golden_test_helpers.dart` to use SourceSans3**

Change line 21 from:
```dart
    fontFamily: 'Roboto',
```
to:
```dart
    fontFamily: 'SourceSans3',
```

**Step 3: Regenerate all golden PNGs**

Run: `fvm flutter test --update-goldens`
Expected: All tests pass and golden files are regenerated with SourceSans3 font.

**Step 4: Verify goldens look correct**

Visually inspect a few golden PNGs to confirm text renders with SourceSans3 (not Ahem squares or Roboto).

**Step 5: Commit**

```bash
git add test/flutter_test_config.dart test/helpers/golden_test_helpers.dart test/goldens/
git commit -m "feat: use SourceSans3 production font in golden tests"
```

---

### Task 2: Fix pubspec.yaml metadata

**Files:**
- Modify: `pubspec.yaml:5-8`

**Step 1: Uncomment homepage, repository, issue_tracker**

Change:
```yaml
# homepage: https://github.com/bassiuz/neo-fade-ui
# repository: https://github.com/bassiuz/neo-fade-ui
# issue_tracker: https://github.com/bassiuz/neo-fade-ui/issues
```
to:
```yaml
homepage: https://github.com/bassiuz/neo-fade-ui
repository: https://github.com/bassiuz/neo-fade-ui
issue_tracker: https://github.com/bassiuz/neo-fade-ui/issues
```

**Step 2: Commit**

```bash
git add pubspec.yaml
git commit -m "chore: uncomment pubspec homepage/repository/issue_tracker"
```

---

### Task 3: Create CHANGELOG.md

**Files:**
- Create: `CHANGELOG.md`

**Step 1: Create CHANGELOG.md**

```markdown
## 0.0.1

- Initial release
- Theme system with glass morphism, gradients, and customizable colors
- Buttons: filled, gradient border, pill, soft, CTA, icon, text, FAB
- Cards: top border, glow outline, left accent, corner splash, bottom fade, diagonal stripe, pulsing glow
- Feature cards: icon top, icon left, icon centered, icon header
- Navigation: bottom nav (dot, pill, expanding, CTA variants), floating actions
- Inputs: text fields (8 variants), checkboxes (8 variants), switches (8 variants), sliders (8 variants), number selectors (4 variants), radio, dropdown, search bar, emoji picker
- Selectors: segmented controls (sliding, pill outline, underline, icon grid, icons)
- Display: chip, badge, avatar, list tile
- Feedback: snackbar, dialog, tooltip, progress indicators
- Layout: app bar, divider
- Foundation: glass container, mesh background, inner border, gradient border
```

**Step 2: Commit**

```bash
git add CHANGELOG.md
git commit -m "docs: add CHANGELOG.md for initial release"
```

---

### Task 4: Add dartdoc to theme files (8 files)

**Files:**
- Modify: `lib/src/theme/neo_fade_colors.dart`
- Modify: `lib/src/theme/neo_fade_glass_properties.dart`
- Modify: `lib/src/theme/neo_fade_radii.dart`
- Modify: `lib/src/theme/neo_fade_shadows.dart`
- Modify: `lib/src/theme/neo_fade_spacing.dart`
- Modify: `lib/src/theme/neo_fade_theme.dart`
- Modify: `lib/src/theme/neo_fade_theme_data.dart`
- Modify: `lib/src/theme/neo_fade_typography.dart`

**Step 1: Read each file and add a `///` dartdoc comment above each public class**

Add a one-line description that explains what the class does. Example:
```dart
/// Defines the color palette for a Neo Fade theme.
class NeoFadeColors {
```

**Step 2: Commit**

```bash
git add lib/src/theme/
git commit -m "docs: add dartdoc comments to theme classes"
```

---

### Task 5: Add dartdoc to foundation and utils files (6 files)

**Files:**
- Modify: `lib/src/foundation/glass_container.dart`
- Modify: `lib/src/foundation/gradient_border.dart`
- Modify: `lib/src/foundation/inner_border.dart`
- Modify: `lib/src/foundation/mesh_background.dart`
- Modify: `lib/src/utils/animation_utils.dart`
- Modify: `lib/src/utils/color_utils.dart`

**Step 1: Read each file and add `///` dartdoc above each public class**

**Step 2: Commit**

```bash
git add lib/src/foundation/ lib/src/utils/
git commit -m "docs: add dartdoc comments to foundation and utils classes"
```

---

### Task 6: Add dartdoc to remaining component files (15 files)

**Files:**
- Modify: `lib/src/components/buttons/neo_button.dart`
- Modify: `lib/src/components/buttons/neo_button_size.dart`
- Modify: `lib/src/components/buttons/neo_button_style.dart`
- Modify: `lib/src/components/buttons/neo_button_variant.dart`
- Modify: `lib/src/components/buttons/neo_cta_button.dart`
- Modify: `lib/src/components/buttons/neo_icon_button.dart`
- Modify: `lib/src/components/containers/neo_card.dart`
- Modify: `lib/src/components/containers/neo_feature_card.dart`
- Modify: `lib/src/components/inputs/neo_checkbox.dart`
- Modify: `lib/src/components/inputs/neo_number_selector.dart`
- Modify: `lib/src/components/inputs/neo_slider.dart`
- Modify: `lib/src/components/inputs/neo_switch.dart`
- Modify: `lib/src/components/inputs/neo_text_field.dart`
- Modify: `lib/src/components/navigation/neo_bottom_nav.dart`
- Modify: `lib/src/components/selectors/neo_segmented_control.dart`

**Step 1: Read each file and add `///` dartdoc above each public class**

**Step 2: Commit**

```bash
git add lib/src/components/
git commit -m "docs: add dartdoc comments to remaining component classes"
```

---

### Task 7: Create example/main.dart

**Files:**
- Create: `example/main.dart`

**Step 1: Create a minimal runnable example**

```dart
import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NeoFadeTheme(
        data: NeoFadeThemeData.fromColors(
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFFF472B6),
          tertiary: const Color(0xFF22D3EE),
          brightness: Brightness.dark,
        ),
        child: const Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NeoButtonFilled(label: 'Hello Neo Fade'),
                SizedBox(height: 16),
                NeoCardTopBorder(child: Text('A glass card')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

**Step 2: Commit**

```bash
git add example/
git commit -m "docs: add minimal example app for pub.dev"
```

---

### Task 8: Update README and library doc for pub.dev

**Files:**
- Modify: `README.md` (on feature/metadata-readme-upgrade branch - merge first)
- Modify: `lib/neo_fade_ui.dart:1-2`

**Step 1: Merge the feature/metadata-readme-upgrade branch into main**

```bash
git merge feature/metadata-readme-upgrade
```

**Step 2: Add pub.dev install section and badge to top of README**

Add after the title and description:

```markdown
[![pub package](https://img.shields.io/pub/v/neo_fade_ui.svg)](https://pub.dev/packages/neo_fade_ui)

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  neo_fade_ui: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

```dart
import 'package:neo_fade_ui/neo_fade_ui.dart';

NeoFadeTheme(
  data: NeoFadeThemeData.fromColors(
    primary: Color(0xFF6366F1),
    secondary: Color(0xFFF472B6),
    brightness: Brightness.dark,
  ),
  child: NeoButtonFilled(label: 'Hello'),
)
```
```

**Step 3: Update library doc in `lib/neo_fade_ui.dart`**

Change line 1-2 from:
```dart
/// Neo Fade UI - A modern Flutter UI component library
library;
```
to:
```dart
/// Neo Fade UI - A modern Flutter UI component library with glass morphism,
/// gradient effects, and customizable themes.
///
/// To get started, wrap your app with [NeoFadeTheme] and provide a
/// [NeoFadeThemeData] created with [NeoFadeThemeData.fromColors].
///
/// ```dart
/// NeoFadeTheme(
///   data: NeoFadeThemeData.fromColors(
///     primary: Color(0xFF6366F1),
///     secondary: Color(0xFFF472B6),
///     brightness: Brightness.dark,
///   ),
///   child: MyApp(),
/// )
/// ```
library;
```

**Step 4: Commit**

```bash
git add README.md lib/neo_fade_ui.dart
git commit -m "docs: add pub.dev install/usage sections and library dartdoc"
```

---

### Task 9: Add build/ to .gitignore

**Files:**
- Modify: `.gitignore`

**Step 1: Add `build/` to .gitignore if not present**

**Step 2: Commit**

```bash
git add .gitignore
git commit -m "chore: add build/ to gitignore"
```

---

### Task 10: Run static analysis and verify

**Step 1: Run analyzer**

Run: `fvm dart analyze`
Expected: No issues.

**Step 2: Dry-run publish check**

Run: `fvm dart pub publish --dry-run`
Expected: No blocking errors.

**Step 3: Run all tests**

Run: `fvm flutter test`
Expected: All tests pass.

**Step 4: Commit any fixes if needed**
