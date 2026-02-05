import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../foundation/gradient_border.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Search input with glass background and gradient focus border.
///
/// A search bar with the Neo Fade glass effect, featuring a gradient
/// border on focus and optional clear button.
class NeoSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final bool enabled;

  const NeoSearchBar({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.enabled = true,
  });

  @override
  State<NeoSearchBar> createState() => NeoSearchBarState();
}

class NeoSearchBarState extends State<NeoSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(_handleTextChange);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleTextChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
    widget.onChanged?.call(_controller.text);
  }

  void _clearText() {
    _controller.clear();
    widget.onClear?.call();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final glass = theme.glass;

    return ClipRRect(
      borderRadius: BorderRadius.circular(NeoFadeRadii.full),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: glass.blur,
          sigmaY: glass.blur,
        ),
        child: AnimatedContainer(
          duration: NeoFadeAnimations.fast,
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: glass.tintOpacity),
            borderRadius: BorderRadius.circular(NeoFadeRadii.full),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: CustomPaint(
            painter: GradientBorderPainter(
              colors: _isFocused
                  ? [colors.primary, colors.secondary, colors.tertiary]
                  : [colors.border.withValues(alpha: 0.3)],
              borderWidth: _isFocused ? 2 : 1,
              borderRadius: BorderRadius.circular(NeoFadeRadii.full),
              bottomOnly: false,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: NeoFadeSpacing.md,
                  ),
                  child: Icon(
                    const IconData(0xe8b6, fontFamily: 'MaterialIcons'), // search
                    size: 20,
                    color: _isFocused ? colors.primary : colors.onSurfaceVariant,
                  ),
                ),
                Expanded(
                  child: EditableText(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: widget.autofocus,
                    style: theme.typography.bodyMedium.copyWith(
                      color: widget.enabled
                          ? colors.onSurface
                          : colors.disabledText,
                    ),
                    cursorColor: colors.primary,
                    backgroundCursorColor: colors.surface,
                    onSubmitted: widget.onSubmitted,
                    readOnly: !widget.enabled,
                  ),
                ),
                if (_hasText)
                  GestureDetector(
                    onTap: _clearText,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: NeoFadeSpacing.sm,
                      ),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Icon(
                          const IconData(0xe5cd,
                              fontFamily: 'MaterialIcons'), // close
                          size: 18,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(width: NeoFadeSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
