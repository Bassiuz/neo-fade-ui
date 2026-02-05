import 'package:flutter/material.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

void main() {
  runApp(const NeoFadeShowcase());
}

class NeoFadeShowcase extends StatefulWidget {
  const NeoFadeShowcase({super.key});

  @override
  State<NeoFadeShowcase> createState() => NeoFadeShowcaseState();
}

class NeoFadeShowcaseState extends State<NeoFadeShowcase> {
  Color primaryColor = const Color(0xFF6366F1);
  Color secondaryColor = const Color(0xFFF472B6);
  Color tertiaryColor = const Color(0xFF22D3EE);
  bool isDarkMode = true;
  bool isAnimated = true;

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeThemeData.fromColors(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    );

    return NeoFadeTheme(
      data: theme,
      child: MaterialApp(
        title: 'Neo Fade UI Showcase',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: ShowcaseHome(
          isDarkMode: isDarkMode,
          onThemeToggle: () => setState(() => isDarkMode = !isDarkMode),
          isAnimated: isAnimated,
          onAnimationToggle: () => setState(() => isAnimated = !isAnimated),
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
          tertiaryColor: tertiaryColor,
          onPrimaryColorChanged: (color) => setState(() => primaryColor = color),
          onSecondaryColorChanged: (color) => setState(() => secondaryColor = color),
          onTertiaryColorChanged: (color) => setState(() => tertiaryColor = color),
        ),
      ),
    );
  }
}

class ShowcaseHome extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final bool isAnimated;
  final VoidCallback onAnimationToggle;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final ValueChanged<Color> onPrimaryColorChanged;
  final ValueChanged<Color> onSecondaryColorChanged;
  final ValueChanged<Color> onTertiaryColorChanged;

  const ShowcaseHome({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.isAnimated,
    required this.onAnimationToggle,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.onPrimaryColorChanged,
    required this.onSecondaryColorChanged,
    required this.onTertiaryColorChanged,
  });

  @override
  State<ShowcaseHome> createState() => ShowcaseHomeState();
}

class ShowcaseHomeState extends State<ShowcaseHome> {
  // Component states
  bool checkboxState = false;
  bool switchState = false;
  double sliderValue = 0.5;
  int numberValue = 5;
  String segmentedValue = 'day';
  String segmentedIconsValue = 'list';
  int bottomNavIndex = 0;

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(NeoFadeSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Neo Fade UI',
                        style: theme.typography.headlineLarge,
                      ),
                      Row(
                        children: [
                          NeoIconButton(
                            icon: widget.isAnimated ? Icons.pause : Icons.play_arrow,
                            onPressed: widget.onAnimationToggle,
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
                    ],
                  ),
                  const SizedBox(height: NeoFadeSpacing.lg),

                  // Theme Colors
                  Text('Theme Colors', style: theme.typography.titleLarge),
                  const SizedBox(height: NeoFadeSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: ColorPickerTile(
                          label: 'Primary',
                          color: widget.primaryColor,
                          onColorChanged: widget.onPrimaryColorChanged,
                        ),
                      ),
                      const SizedBox(width: NeoFadeSpacing.md),
                      Expanded(
                        child: ColorPickerTile(
                          label: 'Secondary',
                          color: widget.secondaryColor,
                          onColorChanged: widget.onSecondaryColorChanged,
                        ),
                      ),
                      const SizedBox(width: NeoFadeSpacing.md),
                      Expanded(
                        child: ColorPickerTile(
                          label: 'Tertiary',
                          color: widget.tertiaryColor,
                          onColorChanged: widget.onTertiaryColorChanged,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: NeoFadeSpacing.xxl),

                  // Card Section
                  Text('Card', style: theme.typography.titleLarge),
                  const SizedBox(height: NeoFadeSpacing.md),
                  Text('NeoCard1 - Gradient Top Border', style: theme.typography.labelMedium),
                  const SizedBox(height: NeoFadeSpacing.sm),
                  NeoCard1(
                    padding: const EdgeInsets.all(NeoFadeSpacing.md),
                    child: Text('This card has a gradient top border accent', style: theme.typography.bodyMedium),
                  ),

                  const SizedBox(height: NeoFadeSpacing.xxl),

                  // TextField Section
                  Text('TextField', style: theme.typography.titleLarge),
                  const SizedBox(height: NeoFadeSpacing.md),
                  Text('NeoTextField2 - Gradient Border on Focus', style: theme.typography.labelMedium),
                  const SizedBox(height: NeoFadeSpacing.sm),
                  const NeoTextField2(hintText: 'Type here to see gradient border...'),

                  const SizedBox(height: NeoFadeSpacing.xxl),

                  // Checkbox Section
                  Text('Checkbox', style: theme.typography.titleLarge),
                  const SizedBox(height: NeoFadeSpacing.md),
                  Text('NeoCheckbox4 - Glow Border', style: theme.typography.labelMedium),
                  const SizedBox(height: NeoFadeSpacing.sm),
                  Row(
                    children: [
                      NeoCheckbox4(
                        value: checkboxState,
                        onChanged: (v) => setState(() => checkboxState = v),
                      ),
                      const SizedBox(width: NeoFadeSpacing.md),
                      Text(
                        checkboxState ? 'Checked' : 'Unchecked',
                        style: theme.typography.bodyMedium,
                      ),
                    ],
                  ),

                  const SizedBox(height: NeoFadeSpacing.xxl),

                  // Switch Section
                  Text('Switch', style: theme.typography.titleLarge),
                  const SizedBox(height: NeoFadeSpacing.md),
                  Text('NeoSwitch2 - iOS Style', style: theme.typography.labelMedium),
                  const SizedBox(height: NeoFadeSpacing.sm),
                  Row(
                    children: [
                      NeoSwitch2(
                        value: switchState,
                        onChanged: (v) => setState(() => switchState = v),
                      ),
                      const SizedBox(width: NeoFadeSpacing.md),
                      Text(
                        switchState ? 'On' : 'Off',
                        style: theme.typography.bodyMedium,
                      ),
                    ],
                  ),

                  const SizedBox(height: NeoFadeSpacing.xxl),

                  // Slider Section
                  Text('Slider', style: theme.typography.titleLarge),
                  const SizedBox(height: NeoFadeSpacing.md),
                  Text('NeoSlider - Subtle Gradient Slider', style: theme.typography.labelMedium),
                  const SizedBox(height: NeoFadeSpacing.sm),
                  NeoSlider(
                    value: sliderValue,
                    onChanged: (v) => setState(() => sliderValue = v),
                  ),
                  const SizedBox(height: NeoFadeSpacing.xs),
                  Text(
                    'Value: ${(sliderValue * 100).toStringAsFixed(0)}%',
                    style: theme.typography.labelSmall,
                  ),

                  const SizedBox(height: NeoFadeSpacing.xxl),

                  // Buttons Section
                  Text('Buttons', style: theme.typography.titleLarge),
                  const SizedBox(height: NeoFadeSpacing.md),
                  Wrap(
                    spacing: NeoFadeSpacing.md,
                    runSpacing: NeoFadeSpacing.md,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NeoButton1 - Gradient Filled', style: theme.typography.labelMedium),
                          const SizedBox(height: NeoFadeSpacing.sm),
                          NeoButton1(label: 'Submit', icon: Icons.check, onPressed: () {}),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NeoButton2 - Gradient Border', style: theme.typography.labelMedium),
                          const SizedBox(height: NeoFadeSpacing.sm),
                          NeoButton2(label: 'Learn More', icon: Icons.info, onPressed: () {}),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: NeoFadeSpacing.xxl),

                  // Pulsing Glow Effect Section
                  Text('Pulsing Glow Effect', style: theme.typography.titleLarge),
                  const SizedBox(height: NeoFadeSpacing.md),
                  Text('NeoPulsingGlow - Wraps any widget with a glow', style: theme.typography.labelMedium),
                  const SizedBox(height: NeoFadeSpacing.sm),
                  Center(
                    child: NeoPulsingGlow(
                      child: NeoButton1(
                        label: 'Glowing Button',
                        icon: Icons.star,
                        onPressed: () {},
                      ),
                    ),
                  ),

                  const SizedBox(height: NeoFadeSpacing.xxl),

                  // Feature Card Section
                  Text('Feature Card', style: theme.typography.titleLarge),
                  const SizedBox(height: NeoFadeSpacing.md),
                  Text('NeoFeatureCard1 - Gradient Icon Box', style: theme.typography.labelMedium),
                  const SizedBox(height: NeoFadeSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: NeoFeatureCard1(
                          icon: Icons.flash_on,
                          title: 'Fast Performance',
                          subtitle: 'Optimized for speed',
                        ),
                      ),
                      const SizedBox(width: NeoFadeSpacing.md),
                      Expanded(
                        child: NeoFeatureCard1(
                          icon: Icons.security,
                          title: 'Secure',
                          subtitle: 'Enterprise-grade',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: NeoFadeSpacing.xxl),

                  // Number Selector Section
                  Text('Number Selector', style: theme.typography.titleLarge),
                  const SizedBox(height: NeoFadeSpacing.md),
                  Text('NeoNumberSelector1 - Horizontal +/-', style: theme.typography.labelMedium),
                  const SizedBox(height: NeoFadeSpacing.sm),
                  NeoNumberSelector1(
                    value: numberValue,
                    onChanged: (v) => setState(() => numberValue = v),
                    min: 0,
                    max: 20,
                  ),

                  const SizedBox(height: NeoFadeSpacing.xxl),

                  // Segmented Controls Section
                  Text('Segmented Controls', style: theme.typography.titleLarge),
                  const SizedBox(height: NeoFadeSpacing.md),
                  Text('NeoSegmentedControl1 - Sliding Gradient', style: theme.typography.labelMedium),
                  const SizedBox(height: NeoFadeSpacing.sm),
                  NeoSegmentedControl1<String>(
                    selectedValue: segmentedValue,
                    onValueChanged: (v) => setState(() => segmentedValue = v),
                    segments: const [
                      NeoSegment(value: 'day', label: 'Day'),
                      NeoSegment(value: 'week', label: 'Week'),
                      NeoSegment(value: 'month', label: 'Month'),
                    ],
                  ),

                  const SizedBox(height: NeoFadeSpacing.lg),

                  Text('NeoSegmentedControlIcons - Icons Above Labels', style: theme.typography.labelMedium),
                  const SizedBox(height: NeoFadeSpacing.sm),
                  NeoSegmentedControlIcons<String>(
                    selectedValue: segmentedIconsValue,
                    onValueChanged: (v) => setState(() => segmentedIconsValue = v),
                    segments: const [
                      NeoSegment(value: 'list', label: 'List', icon: Icons.list),
                      NeoSegment(value: 'grid', label: 'Grid', icon: Icons.grid_view),
                      NeoSegment(value: 'card', label: 'Card', icon: Icons.view_agenda),
                    ],
                  ),

                  const SizedBox(height: NeoFadeSpacing.xxl),

                  // Bottom Navigation Section
                  Text('Bottom Navigation', style: theme.typography.titleLarge),
                  const SizedBox(height: NeoFadeSpacing.md),
                  Text('NeoBottomNavCTA - Floating CTA Button', style: theme.typography.labelMedium),
                  const SizedBox(height: NeoFadeSpacing.sm),
                  SizedBox(
                    height: 120,
                    child: NeoBottomNavCTA(
                      selectedIndex: bottomNavIndex,
                      onIndexChanged: (i) => setState(() => bottomNavIndex = i),
                      items: const [
                        NeoBottomNavItem(icon: Icons.home, label: 'Home'),
                        NeoBottomNavItem(icon: Icons.search, label: 'Search'),
                        NeoBottomNavItem(icon: Icons.favorite, label: 'Favorites'),
                        NeoBottomNavItem(icon: Icons.person, label: 'Profile'),
                      ],
                      onCenterPressed: () {},
                      centerIcon: Icons.add,
                    ),
                  ),

                  const SizedBox(height: NeoFadeSpacing.xxl),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Color Picker Tile
class ColorPickerTile extends StatelessWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerTile({
    super.key,
    required this.label,
    required this.color,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);

    return GlassContainer(
      padding: const EdgeInsets.all(NeoFadeSpacing.md),
      borderRadius: NeoFadeRadii.mdRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.typography.labelMedium),
          const SizedBox(height: NeoFadeSpacing.sm),
          GestureDetector(
            onTap: () => showColorPicker(context),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: NeoFadeRadii.smRadius,
                border: Border.all(color: theme.colors.border, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showColorPicker(BuildContext context) {
    final presetColors = [
      const Color(0xFF6366F1),
      const Color(0xFFF472B6),
      const Color(0xFF22D3EE),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF8B5CF6),
      const Color(0xFF3B82F6),
      const Color(0xFF14B8A6),
      const Color(0xFFEC4899),
      const Color(0xFFF97316),
      const Color(0xFF84CC16),
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeoFadeTheme.of(context).colors.surface,
        title: Text('Select $label Color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: presetColors.map((presetColor) {
            return GestureDetector(
              onTap: () {
                onColorChanged(presetColor);
                Navigator.of(context).pop();
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: presetColor,
                  borderRadius: BorderRadius.circular(8),
                  border: presetColor == color
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
