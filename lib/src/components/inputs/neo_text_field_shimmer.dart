import 'package:flutter/widgets.dart';

import '../../foundation/glass_container.dart';
import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_spacing.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';
import 'gradient_shimmer_painter.dart';

/// Glass field with gradient shimmer cursor line.
///
/// Features a tinted glass background with a unique animated gradient
/// shimmer effect that follows the cursor position when focused.
class NeoTextFieldShimmer extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final String? labelText;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool autofocus;

  const NeoTextFieldShimmer({
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
  State<NeoTextFieldShimmer> createState() => NeoTextFieldShimmerState();
}

class NeoTextFieldShimmerState extends State<NeoTextFieldShimmer>
    with TickerProviderStateMixin {
  late AnimationController _focusAnimationController;
  late AnimationController _shimmerAnimationController;
  late Animation<double> _focusAnimation;
  late FocusNode _focusNode;
  late TextEditingController _controller;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(_handleFocusChange);

    _focusAnimationController = AnimationController(
      duration: NeoFadeAnimations.normal,
      vsync: this,
    );

    _shimmerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _focusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _focusAnimationController,
        curve: NeoFadeAnimations.defaultCurve,
      ),
    );
  }

  @override
  void dispose() {
    _focusAnimationController.dispose();
    _shimmerAnimationController.dispose();
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
      _focusAnimationController.forward();
      _shimmerAnimationController.repeat();
    } else {
      _focusAnimationController.reverse();
      _shimmerAnimationController.stop();
      _shimmerAnimationController.reset();
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
            animation: Listenable.merge([
              _focusAnimationController,
              _shimmerAnimationController,
            ]),
            builder: (context, child) {
              return Stack(
                children: [
                  GlassContainer(
                    borderRadius: borderRadius,
                    borderColor: colors.border,
                    borderWidth: 1.0,
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
                  if (_isFocused)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: NeoFadeSpacing.xxs * 1.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(NeoFadeRadii.input),
                          bottomRight: Radius.circular(NeoFadeRadii.input),
                        ),
                        child: Opacity(
                          opacity: _focusAnimation.value,
                          child: CustomPaint(
                            painter: GradientShimmerPainter(
                              gradientColors: gradientColors,
                              shimmerProgress: _shimmerAnimationController.value,
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
