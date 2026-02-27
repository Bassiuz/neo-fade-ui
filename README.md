# Neo Fade UI

[![pub package](https://img.shields.io/pub/v/neo_fade_ui.svg)](https://pub.dev/packages/neo_fade_ui)

A modern Flutter UI component library featuring glass morphism, gradient effects, and customizable themes.

[**Live Demo**](https://bassiuz.github.io/neo-fade-ui/)

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
  child: Scaffold(
    body: NeoButtonFilled(
      label: 'Hello Neo Fade',
      onPressed: () {},
    ),
  ),
)
```

## Component Showcase

All components support light and dark themes out of the box. Images below are from golden tests.

### Buttons

| Default | Dark | With Icon | Disabled |
|---------|------|-----------|----------|
| ![](test/goldens/neo_button_1_default.png) | ![](test/goldens/neo_button_1_dark.png) | ![](test/goldens/neo_button_1_with_icon.png) | ![](test/goldens/neo_button_1_disabled.png) |
| ![](test/goldens/neo_button_2_default.png) | ![](test/goldens/neo_button_2_dark.png) | ![](test/goldens/neo_button_2_with_icon.png) | ![](test/goldens/neo_button_2_disabled.png) |

### Chips

| Default | Selected | With Icon | Dark | Disabled |
|---------|----------|-----------|------|----------|
| ![](test/goldens/neo_chip_default.png) | ![](test/goldens/neo_chip_selected.png) | ![](test/goldens/neo_chip_with_icon.png) | ![](test/goldens/neo_chip_dark.png) | ![](test/goldens/neo_chip_disabled.png) |

### Cards

| Default | Dark | Rich Content |
|---------|------|--------------|
| ![](test/goldens/neo_card_1_default.png) | ![](test/goldens/neo_card_1_dark.png) | ![](test/goldens/neo_card_1_rich_content.png) |

### Feature Cards

| Default | Dark | No Subtitle |
|---------|------|-------------|
| ![](test/goldens/neo_feature_card_1_default.png) | ![](test/goldens/neo_feature_card_1_dark.png) | ![](test/goldens/neo_feature_card_1_no_subtitle.png) |

### List Tiles

| Default | Dark | Selected | Disabled | With Widgets |
|---------|------|----------|----------|--------------|
| ![](test/goldens/neo_list_tile_default.png) | ![](test/goldens/neo_list_tile_dark.png) | ![](test/goldens/neo_list_tile_selected.png) | ![](test/goldens/neo_list_tile_disabled.png) | ![](test/goldens/neo_list_tile_with_widgets.png) |

### Text Fields

| Default | Dark | With Label | Disabled |
|---------|------|------------|----------|
| ![](test/goldens/neo_text_field_2_default.png) | ![](test/goldens/neo_text_field_2_dark.png) | ![](test/goldens/neo_text_field_2_with_label.png) | ![](test/goldens/neo_text_field_2_disabled.png) |
| ![](test/goldens/neo_text_field_outlined_default.png) | ![](test/goldens/neo_text_field_outlined_dark.png) | ![](test/goldens/neo_text_field_outlined_with_label.png) | ![](test/goldens/neo_text_field_outlined_disabled.png) |

### Checkboxes

| Unchecked | Checked | Dark | With Label | Disabled |
|-----------|---------|------|------------|----------|
| ![](test/goldens/neo_checkbox_4_unchecked.png) | ![](test/goldens/neo_checkbox_4_checked.png) | ![](test/goldens/neo_checkbox_4_dark.png) | ![](test/goldens/neo_checkbox_4_with_label.png) | ![](test/goldens/neo_checkbox_4_disabled.png) |

### Switches

| On | Off | Dark | Disabled |
|----|-----|------|----------|
| ![](test/goldens/neo_switch_2_on.png) | ![](test/goldens/neo_switch_2_off.png) | ![](test/goldens/neo_switch_2_dark.png) | ![](test/goldens/neo_switch_2_disabled.png) |
| ![](test/goldens/neo_switch_ios_on.png) | ![](test/goldens/neo_switch_ios_off.png) | ![](test/goldens/neo_switch_ios_dark.png) | ![](test/goldens/neo_switch_ios_disabled.png) |

### Sliders

| Default | Dark | Min | Max |
|---------|------|-----|-----|
| ![](test/goldens/neo_slider_default.png) | ![](test/goldens/neo_slider_dark.png) | ![](test/goldens/neo_slider_min.png) | ![](test/goldens/neo_slider_max.png) |

### Number Selector

| Default | Dark | Min | Max |
|---------|------|-----|-----|
| ![](test/goldens/neo_number_selector_1_default.png) | ![](test/goldens/neo_number_selector_1_dark.png) | ![](test/goldens/neo_number_selector_1_min.png) | ![](test/goldens/neo_number_selector_1_max.png) |

### Segmented Controls

| First | Middle | Last | Dark |
|-------|--------|------|------|
| ![](test/goldens/neo_segmented_control_1_first.png) | ![](test/goldens/neo_segmented_control_1_middle.png) | ![](test/goldens/neo_segmented_control_1_last.png) | ![](test/goldens/neo_segmented_control_1_dark.png) |
| ![](test/goldens/neo_segmented_control_sliding_first.png) | ![](test/goldens/neo_segmented_control_sliding_middle.png) | ![](test/goldens/neo_segmented_control_sliding_last.png) | ![](test/goldens/neo_segmented_control_sliding_dark.png) |
| ![](test/goldens/neo_segmented_control_icons_first.png) | ![](test/goldens/neo_segmented_control_icons_middle.png) | | ![](test/goldens/neo_segmented_control_icons_dark.png) |

### Avatars

| Initials | Icon | Dark | No Ring |
|----------|------|------|---------|
| ![](test/goldens/neo_avatar_initials.png) | ![](test/goldens/neo_avatar_icon.png) | ![](test/goldens/neo_avatar_dark.png) | ![](test/goldens/neo_avatar_no_ring.png) |

### Badges

| Dot | Count | Large Count | Dark | With Child |
|-----|-------|-------------|------|------------|
| ![](test/goldens/neo_badge_dot.png) | ![](test/goldens/neo_badge_count.png) | ![](test/goldens/neo_badge_large_count.png) | ![](test/goldens/neo_badge_dark.png) | ![](test/goldens/neo_badge_with_child.png) |

### Bottom Navigation

| First | Last | CTA | Dark |
|-------|------|-----|------|
| ![](test/goldens/neo_bottom_nav_cta_first.png) | ![](test/goldens/neo_bottom_nav_cta_last.png) | ![](test/goldens/neo_bottom_nav_cta_camera.png) | ![](test/goldens/neo_bottom_nav_cta_dark.png) |

## Getting Started

This project uses [FVM](https://fvm.app/) to manage the Flutter SDK version.

```bash
# Install FVM if you haven't already
dart pub global activate fvm

# Install the project's Flutter version
fvm install

# Get dependencies
fvm flutter pub get

# Run the showcase app
fvm flutter run

# Run tests
fvm flutter test

# Update golden files
fvm flutter test --update-goldens
```
