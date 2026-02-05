import 'package:flutter/widgets.dart';

import 'neo_circular_progress_indicator.dart';
import 'neo_linear_progress_indicator.dart';

export 'neo_circular_progress_indicator.dart';
export 'neo_linear_progress_indicator.dart';

/// Linear and circular progress indicators with gradient.
///
/// Progress indicators featuring the Neo Fade gradient style
/// with optional glow effects.
class NeoProgressIndicator extends StatelessWidget {
  final double? value;
  final NeoProgressIndicatorType type;
  final double? size;
  final double? strokeWidth;
  final bool showGlow;

  const NeoProgressIndicator({
    super.key,
    this.value,
    this.type = NeoProgressIndicatorType.linear,
    this.size,
    this.strokeWidth,
    this.showGlow = true,
  });

  const NeoProgressIndicator.linear({
    super.key,
    this.value,
    this.showGlow = true,
  })  : type = NeoProgressIndicatorType.linear,
        size = null,
        strokeWidth = null;

  const NeoProgressIndicator.circular({
    super.key,
    this.value,
    this.size = 40,
    this.strokeWidth = 4,
    this.showGlow = true,
  }) : type = NeoProgressIndicatorType.circular;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      NeoProgressIndicatorType.linear => NeoLinearProgressIndicator(
          value: value,
          showGlow: showGlow,
        ),
      NeoProgressIndicatorType.circular => NeoCircularProgressIndicator(
          value: value,
          size: size ?? 40,
          strokeWidth: strokeWidth ?? 4,
          showGlow: showGlow,
        ),
    };
  }
}

/// Type of progress indicator.
enum NeoProgressIndicatorType {
  linear,
  circular,
}
