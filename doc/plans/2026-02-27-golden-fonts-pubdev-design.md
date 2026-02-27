# Golden Font Fix & Pub.dev Readiness

## Goal

1. Golden tests render with SourceSans3 (production font) instead of Roboto
2. Package is ready for pub.dev publishing with maximum pub points

## Part 1: Golden Tests with SourceSans3

### Changes

- **Create `test/flutter_test_config.dart`**: Load SourceSans3 font bytes via `FontLoader` before tests run
- **Update `test/helpers/golden_test_helpers.dart`**: Change `fontFamily: 'Roboto'` to `fontFamily: 'SourceSans3'` in `createTestTypography()`
- **Regenerate all golden PNGs**: `fvm flutter test --update-goldens`

## Part 2: Pub.dev Max Points

### pubspec.yaml
- Uncomment `homepage`, `repository`, `issue_tracker` URLs

### CHANGELOG.md (new)
- Create with initial 0.0.1 entry

### lib/neo_fade_ui.dart
- Add library-level dartdoc comment

### Dartdoc comments
- Add `///` documentation to all public classes, methods, and properties that lack them across lib/src/

### example/main.dart (new)
- Minimal runnable example importing the package and showing a few key components (button, card, theme setup)

### README.md
- Add pub.dev badge, install instructions, and usage code snippet to the existing README from the feature branch

### .gitignore
- Add `build/` to prevent large cache files from being committed
