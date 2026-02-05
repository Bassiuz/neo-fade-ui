import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import 'category_item.dart';
import 'color_picker_tile.dart';
import 'showcase_buttons_page.dart';
import 'showcase_cards_page.dart';
import 'showcase_display_page.dart';
import 'showcase_effects_page.dart';
import 'showcase_feedback_page.dart';
import 'showcase_inputs_page.dart';
import 'showcase_layout_page.dart';
import 'showcase_navigation_page.dart';
import 'showcase_selectors_page.dart';
import 'showcase_typography_page.dart';

/// The home widget for the component browser.
class ComponentBrowserHome extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final ValueChanged<Color> onPrimaryColorChanged;
  final ValueChanged<Color> onSecondaryColorChanged;
  final ValueChanged<Color> onTertiaryColorChanged;

  const ComponentBrowserHome({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.onPrimaryColorChanged,
    required this.onSecondaryColorChanged,
    required this.onTertiaryColorChanged,
  });

  @override
  State<ComponentBrowserHome> createState() => ComponentBrowserHomeState();
}

class ComponentBrowserHomeState extends State<ComponentBrowserHome> {
  int selectedCategoryIndex = 0;
  bool showSettings = false;

  final List<CategoryItem> categories = const [
    CategoryItem(name: 'Buttons', icon: Icons.smart_button),
    CategoryItem(name: 'Inputs', icon: Icons.input),
    CategoryItem(name: 'Cards', icon: Icons.credit_card),
    CategoryItem(name: 'Navigation', icon: Icons.navigation),
    CategoryItem(name: 'Selectors', icon: Icons.toggle_on),
    CategoryItem(name: 'Effects', icon: Icons.auto_awesome),
    CategoryItem(name: 'Display', icon: Icons.view_agenda),
    CategoryItem(name: 'Layout', icon: Icons.view_quilt),
    CategoryItem(name: 'Feedback', icon: Icons.feedback),
    CategoryItem(name: 'Typography', icon: Icons.text_fields),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);

    final background = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colors.surface,
            Color.lerp(theme.colors.surface, theme.colors.primary, 0.15)!,
            Color.lerp(theme.colors.surface, theme.colors.secondary, 0.1)!,
          ],
        ),
      ),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        background,
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(NeoFadeSpacing.lg),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Neo Fade UI',
                              style: theme.typography.headlineMedium,
                            ),
                            Text(
                              categories[selectedCategoryIndex].name,
                              style: theme.typography.bodyMedium.copyWith(
                                color: theme.colors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      NeoIconButton(
                        icon: showSettings ? Icons.close : Icons.palette,
                        onPressed: () => setState(() => showSettings = !showSettings),
                        variant: NeoButtonVariant.ghost,
                      ),
                      const SizedBox(width: NeoFadeSpacing.sm),
                      NeoIconButton(
                        icon: widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        onPressed: widget.onThemeToggle,
                        variant: NeoButtonVariant.ghost,
                      ),
                    ],
                  ),
                ),

                // Settings panel (collapsible)
                if (showSettings)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: NeoFadeSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Theme Colors', style: theme.typography.labelMedium),
                        const SizedBox(height: NeoFadeSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: ColorPickerTile(
                                label: 'Primary',
                                color: widget.primaryColor,
                                onColorChanged: widget.onPrimaryColorChanged,
                              ),
                            ),
                            const SizedBox(width: NeoFadeSpacing.sm),
                            Expanded(
                              child: ColorPickerTile(
                                label: 'Secondary',
                                color: widget.secondaryColor,
                                onColorChanged: widget.onSecondaryColorChanged,
                              ),
                            ),
                            const SizedBox(width: NeoFadeSpacing.sm),
                            Expanded(
                              child: ColorPickerTile(
                                label: 'Tertiary',
                                color: widget.tertiaryColor,
                                onColorChanged: widget.onTertiaryColorChanged,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: NeoFadeSpacing.lg),
                      ],
                    ),
                  ),

                // Content area
                Expanded(
                  child: IndexedStack(
                    index: selectedCategoryIndex,
                    children: const [
                      ShowcaseButtonsPage(),
                      ShowcaseInputsPage(),
                      ShowcaseCardsPage(),
                      ShowcaseNavigationPage(),
                      ShowcaseSelectorsPage(),
                      ShowcaseEffectsPage(),
                      ShowcaseDisplayPage(),
                      ShowcaseLayoutPage(),
                      ShowcaseFeedbackPage(),
                      ShowcaseTypographyPage(),
                    ],
                  ),
                ),

                // Bottom navigation
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: NeoFadeSpacing.md,
                    vertical: NeoFadeSpacing.sm,
                  ),
                  child: GlassContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: NeoFadeSpacing.sm,
                      vertical: NeoFadeSpacing.sm,
                    ),
                    borderRadius: NeoFadeRadii.lgRadius,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(categories.length, (index) {
                        final isSelected = selectedCategoryIndex == index;
                        final category = categories[index];
                        return GestureDetector(
                          onTap: () => setState(() => selectedCategoryIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: NeoFadeSpacing.md,
                              vertical: NeoFadeSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        theme.colors.primary.withValues(alpha: 0.3),
                                        theme.colors.secondary.withValues(alpha: 0.2),
                                      ],
                                    )
                                  : null,
                              borderRadius: NeoFadeRadii.mdRadius,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  category.icon,
                                  size: 24,
                                  color: isSelected
                                      ? theme.colors.primary
                                      : theme.colors.onSurface.withValues(alpha: 0.6),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  category.name,
                                  style: theme.typography.labelSmall.copyWith(
                                    color: isSelected
                                        ? theme.colors.primary
                                        : theme.colors.onSurface.withValues(alpha: 0.6),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
