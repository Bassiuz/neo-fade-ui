import 'package:flutter/widgets.dart';

import '../../foundation/glass_container.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Filled glass field with gradient accent on the left edge.
///
/// Features a filled glass background with a vibrant gradient bar
/// on the left side that becomes more prominent when focused.
class NeoTextFieldLeftAccent extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final String? labelText;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool autofocus;

  const NeoTextFieldLeftAccent({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText,
    this.labelText,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<NeoTextFieldLeftAccent> createState() => NeoTextFieldLeftAccentState();
}

class NeoTextFieldLeftAccentState extends State<NeoTextFieldLeftAccent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _accentWidthAnimation;
  late Animation<double> _accentOpacityAnimation;
  late FocusNode _focusNode;
  late TextEditingController _controller;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(_handleFocusChange);

    _animationController = AnimationController(
      duration: NeoFadeAnimations.normal,
      vsync: this,
    );

    _accentWidthAnimation = Tween<double>(begin: NeoFadeSpacing.xxs, end: NeoFadeSpacing.xs).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: NeoFadeAnimations.defaultCurve,
      ),
    );

    _accentOpacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: NeoFadeAnimations.defaultCurve,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _handleChanged(String value) {
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final gradientColors = [colors.primary, colors.secondary, colors.tertiary];
    final borderRadius = BorderRadius.circular(NeoFadeRadii.input);

    final effectiveOpacity =
        widget.enabled ? 1.0 : NeoFadeAnimations.disabledOpacity;

    return AnimatedOpacity(
      duration: NeoFadeAnimations.fast,
      opacity: effectiveOpacity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.labelText != null) ...[
            Text(
              widget.labelText!,
              style: typography.labelMedium.copyWith(
                color: _isFocused ? colors.primary : colors.onSurfaceVariant,
              ),
            ),
            SizedBox(height: NeoFadeSpacing.xs),
          ],
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: borderRadius,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedContainer(
                      duration: NeoFadeAnimations.fast,
                      width: _accentWidthAnimation.value,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: gradientColors.map((c) =>
                            c.withValues(alpha: _accentOpacityAnimation.value)
                          ).toList(),
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(NeoFadeRadii.input),
                          bottomLeft: Radius.circular(NeoFadeRadii.input),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GlassContainer(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(NeoFadeRadii.input),
                          bottomRight: Radius.circular(NeoFadeRadii.input),
                        ),
                        tintOpacity: 0.8,
                        padding: EdgeInsets.symmetric(
                          horizontal: NeoFadeSpacing.inputPaddingHorizontal,
                          vertical: NeoFadeSpacing.inputPaddingVertical,
                        ),
                        child: Stack(
                          children: [
                            if (widget.hintText != null && _controller.text.isEmpty)
                              IgnorePointer(
                                child: Text(
                                  widget.hintText!,
                                  style: typography.bodyMedium.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            EditableText(
                              controller: _controller,
                              focusNode: _focusNode,
                              style: typography.bodyMedium.copyWith(
                                color: colors.onSurface,
                              ),
                              cursorColor: colors.primary,
                              backgroundCursorColor: colors.surfaceVariant,
                              onChanged: _handleChanged,
                              obscureText: widget.obscureText,
                              keyboardType: widget.keyboardType,
                              autofocus: widget.autofocus,
                              readOnly: !widget.enabled,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              );
            },
          ),
        ],
      ),
    );
  }
}
