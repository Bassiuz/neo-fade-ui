import 'package:flutter/widgets.dart';

import '../../foundation/glass_container.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Glass field with floating label and gradient glow on focus.
///
/// Features a tinted glass background with a floating label that
/// animates up when focused or has content. A gradient glow appears
/// around the field when focused.
class NeoTextField5 extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final String labelText;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool autofocus;

  const NeoTextField5({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText,
    required this.labelText,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<NeoTextField5> createState() => NeoTextField5State();
}

class NeoTextField5State extends State<NeoTextField5>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;
  late FocusNode _focusNode;
  late TextEditingController _controller;

  bool _isFocused = false;

  bool get _shouldFloat => _isFocused || _controller.text.isNotEmpty;

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

    _floatAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: NeoFadeAnimations.defaultCurve,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: NeoFadeAnimations.defaultCurve,
      ),
    );

    if (_controller.text.isNotEmpty) {
      _animationController.value = 1.0;
    }
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
    _updateAnimation();
  }

  void _handleTextChange() {
    _updateAnimation();
  }

  void _updateAnimation() {
    if (_shouldFloat) {
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
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              boxShadow: _isFocused
                  ? [
                      for (int i = 0; i < gradientColors.length; i++)
                        BoxShadow(
                          color: gradientColors[i].withValues(
                            alpha: 0.3 * _glowAnimation.value,
                          ),
                          blurRadius: NeoFadeSpacing.lg * _glowAnimation.value,
                          spreadRadius: NeoFadeSpacing.xxs * i * _glowAnimation.value,
                        ),
                    ]
                  : null,
            ),
            child: GlassContainer(
              borderRadius: borderRadius,
              padding: EdgeInsets.only(
                left: NeoFadeSpacing.inputPaddingHorizontal,
                right: NeoFadeSpacing.inputPaddingHorizontal,
                top: NeoFadeSpacing.inputPaddingVertical +
                    (_floatAnimation.value * NeoFadeSpacing.md),
                bottom: NeoFadeSpacing.inputPaddingVertical,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: -NeoFadeSpacing.md * _floatAnimation.value -
                        NeoFadeSpacing.inputPaddingVertical * (1 - _floatAnimation.value),
                    child: AnimatedDefaultTextStyle(
                      duration: NeoFadeAnimations.fast,
                      style: TextStyle(
                        fontSize: typography.bodyMedium.fontSize! -
                            (_floatAnimation.value * 2),
                        color: _isFocused
                            ? colors.primary
                            : colors.onSurfaceVariant,
                        fontWeight: _isFocused
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      child: Text(widget.labelText),
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
          );
        },
      ),
    );
  }
}
