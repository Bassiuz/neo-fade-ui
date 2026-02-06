import 'package:flutter/widgets.dart';

import '../../foundation/glass_container.dart';
import '../../foundation/gradient_border.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Glass container text field with gradient underline that animates on focus.
///
/// Features a tinted glass background with a vibrant gradient underline
/// that becomes visible and animates when the field receives focus.
class NeoTextFieldUnderline extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final String? labelText;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool autofocus;

  const NeoTextFieldUnderline({
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
  State<NeoTextFieldUnderline> createState() => NeoTextFieldUnderlineState();
}

class NeoTextFieldUnderlineState extends State<NeoTextFieldUnderline>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _underlineWidthAnimation;
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

    _underlineWidthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
              return GradientBorder(
                colors: gradientColors,
                borderWidth: _underlineWidthAnimation.value *
                    NeoFadeSpacing.xxs *
                    1.5,
                borderRadius: borderRadius,
                bottomOnly: true,
                child: child,
              );
            },
            child: GlassContainer(
              borderRadius: borderRadius,
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
    );
  }
}
