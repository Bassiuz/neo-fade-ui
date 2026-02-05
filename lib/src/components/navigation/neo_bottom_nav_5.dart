import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_bottom_nav_1.dart';

/// Bottom navigation with prominent center CTA button.
class NeoBottomNav5 extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<NeoBottomNavItem> items;
  final VoidCallback onCenterPressed;
  final IconData centerIcon;

  const NeoBottomNav5({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.items,
    required this.onCenterPressed,
    this.centerIcon = const IconData(0xe145, fontFamily: 'MaterialIcons'), // add icon
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final leftItems = items.take((items.length / 2).floor()).toList();
    final rightItems = items.skip((items.length / 2).floor()).toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(NeoFadeRadii.xl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: NeoFadeSpacing.sm,
            vertical: NeoFadeSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: glass.tintOpacity + 0.1),
            borderRadius: BorderRadius.circular(NeoFadeRadii.xl),
            border: Border.all(
              color: colors.border.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Left items
              ...leftItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == selectedIndex;
                return _NavItem(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => onIndexChanged(index),
                  colors: colors,
                );
              }),

              // Center CTA button
              _CenterButton(
                icon: centerIcon,
                onPressed: onCenterPressed,
                colors: colors,
              ),

              // Right items
              ...rightItems.asMap().entries.map((entry) {
                final index = entry.key + leftItems.length;
                final item = entry.value;
                final isSelected = index == selectedIndex;
                return _NavItem(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => onIndexChanged(index),
                  colors: colors,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final NeoBottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final dynamic colors;

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: NeoFadeAnimations.normal,
        padding: const EdgeInsets.symmetric(
          horizontal: NeoFadeSpacing.md,
          vertical: NeoFadeSpacing.sm,
        ),
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
  }
}

class _CenterButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final dynamic colors;

  const _CenterButton({
    required this.icon,
    required this.onPressed,
    required this.colors,
  });

  @override
  State<_CenterButton> createState() => _CenterButtonState();
}

class _CenterButtonState extends State<_CenterButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

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
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.05),
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(NeoFadeSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [widget.colors.primary, widget.colors.secondary],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.colors.primary.withValues(alpha: 0.4),
                blurRadius: NeoFadeSpacing.md,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
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
