import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../foundation/gradient_border.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'neo_dropdown_item.dart';
import 'neo_dropdown_overlay.dart';

export 'neo_dropdown_item.dart';

/// Glass dropdown with gradient border using Overlay.
///
/// A dropdown selector with tinted glass effect and gradient border
/// that opens a glass overlay for option selection.
class NeoDropdown<T> extends StatefulWidget {
  final T? value;
  final List<NeoDropdownItem<T>> items;
  final ValueChanged<T>? onChanged;
  final String? hint;
  final bool enabled;

  const NeoDropdown({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.hint,
    this.enabled = true,
  });

  @override
  State<NeoDropdown<T>> createState() => NeoDropdownState<T>();
}

class NeoDropdownState<T> extends State<NeoDropdown<T>>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.normal,
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: NeoFadeAnimations.defaultCurve,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: NeoFadeAnimations.defaultCurve,
      ),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (!widget.enabled) return;

    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
    _controller.forward();
  }

  void _closeDropdown() {
    _controller.reverse().then((_) {
      _removeOverlay();
    });
    setState(() => _isOpen = false);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectItem(T value) {
    widget.onChanged?.call(value);
    _closeDropdown();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _closeDropdown,
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + NeoFadeSpacing.xs),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        alignment: Alignment.topCenter,
                        child: child,
                      ),
                    );
                  },
                  child: NeoDropdownOverlay<T>(
                    items: widget.items,
                    selectedValue: widget.value,
                    onSelect: _selectItem,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    final selectedItem = widget.items.cast<NeoDropdownItem<T>?>().firstWhere(
          (item) => item?.value == widget.value,
          orElse: () => null,
        );

    final displayText = selectedItem?.label ?? widget.hint ?? '';
    final isHint = selectedItem == null;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.enabled ? _toggleDropdown : null,
        child: MouseRegion(
          cursor: widget.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(NeoFadeRadii.input),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: glass.blur,
                sigmaY: glass.blur,
              ),
              child: CustomPaint(
                painter: GradientBorderPainter(
                  colors: _isOpen
                      ? [colors.primary, colors.secondary, colors.tertiary]
                      : [colors.border, colors.border],
                  borderWidth: _isOpen ? 2 : 1,
                  borderRadius: BorderRadius.circular(NeoFadeRadii.input),
                  bottomOnly: false,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: NeoFadeSpacing.inputPaddingHorizontal,
                    vertical: NeoFadeSpacing.inputPaddingVertical,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: glass.tintOpacity),
                    borderRadius: BorderRadius.circular(NeoFadeRadii.input),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          displayText,
                          style: theme.typography.bodyMedium.copyWith(
                            color: widget.enabled
                                ? (isHint
                                    ? colors.onSurfaceVariant
                                    : colors.onSurface)
                                : colors.disabledText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AnimatedRotation(
                        duration: NeoFadeAnimations.fast,
                        turns: _isOpen ? 0.5 : 0,
                        child: Icon(
                          const IconData(0xe5cf,
                              fontFamily: 'MaterialIcons'), // expand_more
                          size: 20,
                          color: widget.enabled
                              ? colors.onSurfaceVariant
                              : colors.disabledText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
