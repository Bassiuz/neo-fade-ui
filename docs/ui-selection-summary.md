# Neo Fade UI - Selected Components

## What you like about this UI pack:
- Tinted glass aesthetic with subtle gradient accents
- Gradient borders/accents that activate on interaction (focus, selection)
- Soft glows that draw attention without being overwhelming
- Clean, modern feel with Source Sans typography

## Final Component Set

### Original Selected Components

| Component | Style | Status |
|-----------|-------|--------|
| **NeoCard1** | Gradient top border | Kept as-is |
| **NeoTextField2** | Gradient border on focus | Bug fixed (hint text now disappears when typing) |
| **NeoCheckbox4** | Glow border | Kept as-is |
| **NeoSwitch2** | iOS style | Kept as-is |
| **NeoButton1** | Gradient filled | Kept as-is |
| **NeoButton2** | Gradient border | Kept as-is |
| **NeoFeatureCard1** | Gradient icon box | Kept as-is |
| **NeoBottomNav5/6** | Center CTA | Improved (see NeoBottomNavCTA) |
| **NeoNumberSelector1** | Horizontal +/- | Kept as-is |
| **NeoSegmentedControl1** | Sliding gradient | Kept as-is |

### New Components Created

#### Effects
| Component | Description |
|-----------|-------------|
| **NeoPulsingGlow** | Wrapper widget that adds animated pulsing glow effect for drawing attention |

#### Custom Components
| Component | Description |
|-----------|-------------|
| **NeoSlider** | Subtle, minimal slider with gradient thumb and track |
| **NeoBottomNavCTA** | Animated bottom navigation with rounded-square CTA button that clips navigation bar |
| **NeoSegmentedControlIcons** | Segmented control variant with icons positioned above labels |

#### Material Design Components

**Buttons**
| Component | Description |
|-----------|-------------|
| **NeoFAB** | Floating action button with gradient fill and glow effect |
| **NeoTextButton** | Text-only button with gradient text on hover/press |

**Inputs**
| Component | Description |
|-----------|-------------|
| **NeoRadioButton** | Radio button with gradient fill and glow when selected |
| **NeoDropdown** | Dropdown selector with gradient border on focus |
| **NeoSearchBar** | Search input field with gradient border and search icon |

**Feedback**
| Component | Description |
|-----------|-------------|
| **NeoSnackbar** | Toast/snackbar notification with gradient accent and optional action |
| **NeoDialog** | Modal dialog with gradient top border accent |
| **NeoTooltip** | Tooltip with subtle gradient border |
| **NeoProgressIndicator** | Linear progress indicator with animated gradient fill |

**Display**
| Component | Description |
|-----------|-------------|
| **NeoChip** | Chip/tag component with gradient border when selected |
| **NeoBadge** | Badge/notification indicator with gradient fill |
| **NeoAvatar** | Avatar with optional gradient border ring |
| **NeoListTile** | List tile with gradient accent on selection |

**Layout**
| Component | Description |
|-----------|-------------|
| **NeoAppBar** | App bar with gradient bottom border accent |
| **NeoDivider** | Divider line with optional gradient |

## Bug Fixes
- **NeoTextField2**: Fixed hint text not disappearing when typing

## Component Browser

A component browser app is available to view all components and their variants:

```bash
fvm flutter run -d chrome
```

The browser displays:
- All components organized by category
- Interactive examples showing component states
- Visual comparison of variants

## File Structure

All UI components are located in `/lib/ui/` organized by type:
- `/lib/ui/buttons/` - Button variants (NeoButton1, NeoButton2, NeoFAB, NeoTextButton)
- `/lib/ui/cards/` - Card components (NeoCard1, NeoFeatureCard1)
- `/lib/ui/inputs/` - Input components (NeoTextField2, NeoCheckbox4, NeoSwitch2, NeoRadioButton, NeoDropdown, NeoSearchBar, NeoSlider, NeoNumberSelector1)
- `/lib/ui/navigation/` - Navigation components (NeoBottomNav5, NeoBottomNav6, NeoBottomNavCTA, NeoSegmentedControl1, NeoSegmentedControlIcons, NeoAppBar)
- `/lib/ui/feedback/` - Feedback components (NeoSnackbar, NeoDialog, NeoTooltip, NeoProgressIndicator)
- `/lib/ui/display/` - Display components (NeoChip, NeoBadge, NeoAvatar, NeoListTile, NeoDivider)
- `/lib/ui/effects/` - Effect wrappers (NeoPulsingGlow)
