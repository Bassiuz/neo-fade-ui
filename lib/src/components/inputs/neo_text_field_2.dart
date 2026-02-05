import 'package:flutter/widgets.dart';

import '../../foundation/glass_container.dart';
import '../../foundation/gradient_border.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Outlined glass field with gradient border on focus.
///
/// Features a subtle glass background with a full gradient border
/// that animates in from transparent when the field receives focus.
class NeoTextField2 extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final String? labelText;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool autofocus;

  /// Optional border radius. Defaults to NeoFadeRadii.input.
  final double? borderRadius;

  /// Optional border width for the gradient focus border. Defaults to NeoFadeSpacing.xxs.
  final double? borderWidth;

  /// Optional content padding. Defaults to horizontal: inputPaddingHorizontal, vertical: inputPaddingVertical.
  final EdgeInsetsGeometry? contentPadding;

  /// Optional hint text style. Color defaults to onSurfaceVariant if not specified.
  final TextStyle? hintStyle;

  const NeoTextField2({
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
    this.borderRadius,
    this.borderWidth,
    this.contentPadding,
    this.hintStyle,
  });

  @override
  State<NeoTextField2> createState() => NeoTextField2State();
}

class NeoTextField2State extends State<NeoTextField2>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _borderOpacityAnimation;
  late FocusNode _focusNode;
  late TextEditingController _controller;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(_handleTextChange);

    _animationController = AnimationController(
      duration: NeoFadeAnimations.normal,
      vsync: this,
    );

    _borderOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: NeoFadeAnimations.defaultCurve,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.removeListener(_handleTextChange);
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

  void _handleTextChange() {
    setState(() {});
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
    final effectiveBorderRadius = BorderRadius.circular(widget.borderRadius ?? NeoFadeRadii.input);
    final effectiveBorderWidth = widget.borderWidth ?? NeoFadeSpacing.xxs;
    final effectiveContentPadding = widget.contentPadding ??
        EdgeInsets.symmetric(
          horizontal: NeoFadeSpacing.inputPaddingHorizontal,
          vertical: NeoFadeSpacing.inputPaddingVertical,
        );
    final effectiveHintStyle = widget.hintStyle ??
        typography.bodyMedium.copyWith(
          color: colors.onSurfaceVariant,
        );

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
              return Stack(
                children: [
                  GlassContainer(
                    borderRadius: effectiveBorderRadius,
                    borderColor: colors.border,
                    borderWidth: 1.0,
                    padding: effectiveContentPadding,
                    child: Stack(
                      children: [
                        if (widget.hintText != null && _controller.text.isEmpty)
                          IgnorePointer(
                            child: Text(
                              widget.hintText!,
                              style: effectiveHintStyle,
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
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: _borderOpacityAnimation.value,
                        child: CustomPaint(
                          painter: GradientBorderPainter(
                            colors: gradientColors,
                            borderWidth: effectiveBorderWidth,
                            borderRadius: effectiveBorderRadius,
                            bottomOnly: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
