import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_bottom_nav_1.dart';

/// Bottom navigation with floating elevated center CTA button.
class NeoBottomNav6 extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<NeoBottomNavItem> items;
  final VoidCallback onCenterPressed;
  final IconData centerIcon;

  const NeoBottomNav6({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.items,
    required this.onCenterPressed,
    this.centerIcon = const IconData(0xe3af, fontFamily: 'MaterialIcons'), // camera icon
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final leftItems = items.take((items.length / 2).floor()).toList();
    final rightItems = items.skip((items.length / 2).floor()).toList();

    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        // Nav bar
        ClipRRect(
          borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: NeoFadeSpacing.md,
                vertical: NeoFadeSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: glass.tintOpacity + 0.1),
                borderRadius: BorderRadius.circular(NeoFadeRadii.lg),
                border: Border.all(
                  color: colors.border.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Left items
                  ...leftItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = index == selectedIndex;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onIndexChanged(index),
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.icon,
                              size: 24,
                              color: isSelected ? colors.primary : colors.onSurfaceVariant,
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
                    );
                  }),

                  // Spacer for center button
                  const SizedBox(width: 70),

                  // Right items
                  ...rightItems.asMap().entries.map((entry) {
                    final index = entry.key + leftItems.length;
                    final item = entry.value;
                    final isSelected = index == selectedIndex;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onIndexChanged(index),
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.icon,
                              size: 24,
                              color: isSelected ? colors.primary : colors.onSurfaceVariant,
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
                    );
                  }),
                ],
              ),
            ),
          ),
        ),

        // Floating center button
        Positioned(
          top: -25,
          child: _FloatingCenterButton(
            icon: centerIcon,
            onPressed: onCenterPressed,
            colors: colors,
          ),
        ),
      ],
    );
  }
}

class _FloatingCenterButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final dynamic colors;

  const _FloatingCenterButton({
    required this.icon,
    required this.onPressed,
    required this.colors,
  });

  @override
  State<_FloatingCenterButton> createState() => _FloatingCenterButtonState();
}

class _FloatingCenterButtonState extends State<_FloatingCenterButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.fast,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.05),
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(NeoFadeSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.colors.primary,
                widget.colors.secondary,
                widget.colors.tertiary,
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.colors.primary.withValues(alpha: 0.5),
                blurRadius: NeoFadeSpacing.lg,
                spreadRadius: NeoFadeSpacing.xxs,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: widget.colors.secondary.withValues(alpha: 0.3),
                blurRadius: NeoFadeSpacing.xl,
                spreadRadius: 0,
              ),
            ],
            border: Border.all(
              color: const Color(0xFFFFFFFF).withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Icon(
            widget.icon,
            size: 32,
            color: widget.colors.onPrimary,
          ),
        ),
      ),
    );
  }
}
