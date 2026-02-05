import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_radii.dart';
import '../../theme/neo_fade_theme.dart';
import '../../utils/animation_utils.dart';

/// Linear progress indicator with gradient fill.
class NeoLinearProgressIndicator extends StatefulWidget {
  final double? value;
  final bool showGlow;
  final double height;

  const NeoLinearProgressIndicator({
    super.key,
    this.value,
    this.showGlow = true,
    this.height = 6,
  });

  @override
  State<NeoLinearProgressIndicator> createState() =>
      NeoLinearProgressIndicatorState();
}

class NeoLinearProgressIndicatorState extends State<NeoLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool get _isIndeterminate => widget.value == null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    if (_isIndeterminate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(NeoLinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isIndeterminate != (oldWidget.value == null)) {
      if (_isIndeterminate) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final colors = theme.colors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(NeoFadeRadii.full),
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: colors.surfaceVariant.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(NeoFadeRadii.full),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                if (_isIndeterminate) {
                  final animValue = _controller.value;
                  final startPos = (animValue * 1.5 - 0.25) * width;
                  final barWidth = width * 0.4;

                  return Stack(
                    children: [
                      Positioned(
                        left: startPos,
                        child: Container(
                          width: barWidth,
                          height: widget.height,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colors.primary,
                                colors.secondary,
                                colors.tertiary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(NeoFadeRadii.full),
                            boxShadow: widget.showGlow
                                ? [
                                    BoxShadow(
                                      color: colors.primary.withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  final progressWidth = width * (widget.value ?? 0).clamp(0.0, 1.0);

                  return Stack(
                    children: [
                      AnimatedContainer(
                        duration: NeoFadeAnimations.normal,
                        width: progressWidth,
                        height: widget.height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors.primary,
                              colors.secondary,
                              colors.tertiary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(NeoFadeRadii.full),
                          boxShadow: widget.showGlow
                              ? [
                                  BoxShadow(
                                    color: colors.primary.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
