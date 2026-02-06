import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'gradient_underline_painter.dart';

/// Minimal underline text field with gradient color on focus.
///
/// A clean, minimal design featuring only an underline that transforms
/// from a subtle border to a vibrant gradient when the field receives focus.
class NeoTextFieldMinimal extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final String? labelText;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool autofocus;

  const NeoTextFieldMinimal({
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
  State<NeoTextFieldMinimal> createState() => NeoTextFieldMinimalState();
}

class NeoTextFieldMinimalState extends State<NeoTextFieldMinimal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _gradientAnimation;
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

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
            AnimatedDefaultTextStyle(
              duration: NeoFadeAnimations.fast,
              style: typography.labelMedium.copyWith(
                color: _isFocused ? colors.primary : colors.onSurfaceVariant,
              ),
              child: Text(widget.labelText!),
            ),
            SizedBox(height: NeoFadeSpacing.xs),
          ],
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
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
                  SizedBox(height: NeoFadeSpacing.xxs),
                  CustomPaint(
                    size: Size(double.infinity, NeoFadeSpacing.xxs),
                    painter: GradientUnderlinePainter(
                      gradientColors: gradientColors,
                      baseColor: colors.border,
                      progress: _gradientAnimation.value,
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
