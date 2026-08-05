## 0.1.1

### Fixed

- **Text fields could not be pasted into.** `NeoTextFieldUnderline` was built
  on a bare `EditableText`, which has no selection controls — no long-press
  menu, so no select, copy or paste. Pasting a token on a phone was impossible.
  It is now a `TextField`, which also renders the hint natively instead of
  faking it behind the cursor.
- **Gradient borders were drawn behind the field, not on it.** `GradientBorder`
  used `CustomPaint(painter:)`, which paints beneath the child, so a field with
  its own glass fill covered its own border — leaving only the slivers the
  rounded corners did not reach. It now uses `foregroundPainter`.

### Known

The other seven text field variants (`outlined`, `pill`, `minimal`,
`floatingLabel`, `leftAccent`, `shimmer`, `cornerBadges`) are still built on
`EditableText` and have the same selection problem. Only `underline` is fixed
here.

## 0.1.0

Fixes found by building a full app (Moxly) on the library, each of which had
forced a local reimplementation of the component.

### Fixed

- **Icons rendered as empty boxes.** Nine components built their icons as
  `const IconData(0xNNNN, fontFamily: 'MaterialIcons')` using codepoints from
  an older MaterialIcons font — `Icons.search` is `0xe567`, not `0xe8b6` — so
  they showed as missing glyphs on current Flutter versions. They now use the
  `Icons` constants. Affects `NeoSearchBar`, `NeoAvatar`, `NeoChip`,
  `NeoSnackbar`, `NeoBottomNav`, `NeoBottomNavCTA`, `NeoBottomNavCTASimple`,
  `NeoFeatureCardIconLeft` and the number selectors.
- **`NeoSearchBar` ignored its `hint`** and was 20 logical pixels tall, less
  than a line of body text. It was built on a bare `EditableText`, the raw
  editing primitive with no decoration; it is now a `TextField` that renders
  the hint and has room for its content.
- **`NeoSearchBar.onChanged` fired on programmatic changes.** It came from a
  controller listener, so assigning `controller.text` reported back as though
  the user had typed. It now comes from the field.
- **Buttons overflowed when width-constrained.** `NeoButtonFilled`,
  `NeoButtonGradientBorder`, `NeoButtonPill`, `NeoButtonSoft` and
  `NeoTextButton` laid their label out with no `Flexible`, so a button inside
  an `Expanded` or a `SizedBox` overflowed instead of ellipsising.
  Unconstrained buttons are unchanged.

### Added

- **`NeoListTile.titleMaxLines` / `.subtitleMaxLines`** — cap the text so the
  row cannot grow. Required for lists with a fixed `itemExtent`, where a
  wrapping title overflows the extent. Both default to null, which is the
  previous wrapping behaviour.
- **`NeoFadingAppBar`** — a full-bleed title bar that fades into the
  background: transparent behind the status bar, solid behind the title, and a
  hard bottom edge with a gradient hairline. Complements `NeoAppBar`, which
  keeps its own surface.

### Internal

- The golden suite was red on main and could not run at all: the test config
  resolved the SDK through a `.fvm/flutter_sdk` symlink that current fvm
  versions no longer create. It now locates MaterialIcons from the test
  runner's own binary. 35 stale goldens regenerated, and `test/goldens/failures/`
  diff artefacts removed from version control.
- New non-golden tests cover the icon constants, the search bar's behaviour,
  and layout under constraint — the three areas that had no coverage, which is
  why these bugs shipped.

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
