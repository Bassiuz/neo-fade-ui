import 'dart:ui';

import 'package:flutter/material.dart';

import '../../foundation/gradient_border.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import 'neo_dropdown_item.dart';

/// Overlay for NeoDropdown that displays the list of items.
class NeoDropdownOverlay<T> extends StatelessWidget {
  final List<NeoDropdownItem<T>> items;
  final T? selectedValue;
  final ValueChanged<T> onSelect;

  const NeoDropdownOverlay({
    super.key,
    required this.items,
    this.selectedValue,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    return ClipRRect(
      borderRadius: BorderRadius.circular(NeoFadeRadii.input),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: glass.blur,
          sigmaY: glass.blur,
        ),
        child: CustomPaint(
          painter: GradientBorderPainter(
            colors: [colors.primary, colors.secondary, colors.tertiary],
            borderWidth: 1.5,
            borderRadius: BorderRadius.circular(NeoFadeRadii.input),
            bottomOnly: false,
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: glass.tintOpacity + 0.1),
              borderRadius: BorderRadius.circular(NeoFadeRadii.input),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: NeoFadeSpacing.xs),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item.value == selectedValue;

                return NeoDropdownItemWidget<T>(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => onSelect(item.value),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget for individual dropdown item.
class NeoDropdownItemWidget<T> extends StatefulWidget {
  final NeoDropdownItem<T> item;
  final bool isSelected;
  final VoidCallback onTap;

  const NeoDropdownItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<NeoDropdownItemWidget<T>> createState() =>
      NeoDropdownItemWidgetState<T>();
}

class NeoDropdownItemWidgetState<T> extends State<NeoDropdownItemWidget<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: NeoFadeSpacing.inputPaddingHorizontal,
            vertical: NeoFadeSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? LinearGradient(
                    colors: [
                      colors.primary.withValues(alpha: 0.2),
                      colors.secondary.withValues(alpha: 0.1),
                    ],
                  )
                : null,
            color: _isHovered && !widget.isSelected
                ? colors.surfaceVariant.withValues(alpha: 0.5)
                : null,
          ),
          child: Row(
            children: [
              if (widget.item.icon != null) ...[
                Icon(
                  widget.item.icon,
                  size: 18,
                  color: widget.isSelected
                      ? colors.primary
                      : colors.onSurfaceVariant,
                ),
                const SizedBox(width: NeoFadeSpacing.sm),
              ],
              Expanded(
                child: Text(
                  widget.item.label,
                  style: theme.typography.bodyMedium.copyWith(
                    color:
                        widget.isSelected ? colors.primary : colors.onSurface,
                    fontWeight:
                        widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              if (widget.isSelected)
                Icon(
                  Icons.check,
                  size: 18,
                  color: colors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
