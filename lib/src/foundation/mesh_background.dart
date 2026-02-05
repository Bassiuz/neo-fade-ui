import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

import '../theme/neo_fade_theme.dart';

class MeshBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final bool animated;
  final double? speed;
  final double? frequency;
  final double? amplitude;
  final double? grain;
  final bool useFallbackOnWeb;

  const MeshBackground({
    super.key,
    required this.child,
    this.colors,
    this.animated = true,
    this.speed,
    this.frequency,
    this.amplitude,
    this.grain,
    this.useFallbackOnWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeoFadeTheme.of(context);
    final themeColors = theme.colors;

    final effectiveColors = colors ??
        [
          themeColors.primary,
          themeColors.secondary,
          themeColors.tertiary,
          themeColors.surface,
        ];

    final gradientColors = _ensureFourColors(effectiveColors);

    // Use fallback gradient on web if requested or if shader might fail
    if (kIsWeb && useFallbackOnWeb) {
      return Stack(
        fit: StackFit.expand,
        children: [
          _buildFallbackGradient(gradientColors),
          child,
        ],
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        _MeshGradientWithFallback(
          colors: gradientColors,
          animated: animated,
          speed: speed,
          frequency: frequency,
          amplitude: amplitude,
          grain: grain,
        ),
        child,
      ],
    );
  }

  Widget _buildFallbackGradient(List<Color> colors) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
          stops: const [0.0, 0.33, 0.66, 1.0],
        ),
      ),
    );
  }

  List<Color> _ensureFourColors(List<Color> colors) {
    if (colors.length >= 4) {
      return colors.sublist(0, 4);
    }

    final result = List<Color>.from(colors);
    while (result.length < 4) {
      result.add(colors[result.length % colors.length]);
    }
    return result;
  }
}

class _MeshGradientWithFallback extends StatefulWidget {
  final List<Color> colors;
  final bool animated;
  final double? speed;
  final double? frequency;
  final double? amplitude;
  final double? grain;

  const _MeshGradientWithFallback({
    required this.colors,
    required this.animated,
    this.speed,
    this.frequency,
    this.amplitude,
    this.grain,
  });

  @override
  State<_MeshGradientWithFallback> createState() => _MeshGradientWithFallbackState();
}

class _MeshGradientWithFallbackState extends State<_MeshGradientWithFallback> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildFallbackGradient();
    }

    return _ErrorBoundary(
      onError: () {
        if (mounted) {
          setState(() => _hasError = true);
        }
      },
      child: widget.animated
          ? AnimatedMeshGradient(
              colors: widget.colors,
              options: AnimatedMeshGradientOptions(
                speed: widget.speed ?? 2,
                frequency: widget.frequency ?? 3,
                amplitude: widget.amplitude ?? 30,
                grain: widget.grain ?? 0.3,
              ),
            )
          : MeshGradient(
              points: _createStaticPoints(widget.colors),
              options: MeshGradientOptions(
                blend: 3.5,
                noiseIntensity: 0.5,
              ),
            ),
    );
  }

  Widget _buildFallbackGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.colors,
          stops: const [0.0, 0.33, 0.66, 1.0],
        ),
      ),
    );
  }

  List<MeshGradientPoint> _createStaticPoints(List<Color> colors) {
    return [
      MeshGradientPoint(
        position: const Offset(0.1, 0.1),
        color: colors[0],
      ),
      MeshGradientPoint(
        position: const Offset(0.9, 0.2),
        color: colors[1],
      ),
      MeshGradientPoint(
        position: const Offset(0.2, 0.8),
        color: colors[2],
      ),
      MeshGradientPoint(
        position: const Offset(0.8, 0.9),
        color: colors[3],
      ),
    ];
  }
}

class _ErrorBoundary extends StatefulWidget {
  final Widget child;
  final VoidCallback onError;

  const _ErrorBoundary({
    required this.child,
    required this.onError,
  });

  @override
  State<_ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<_ErrorBoundary> {
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (details) {
      if (!_hasError) {
        _hasError = true;
        widget.onError();
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const SizedBox.shrink();
    }
    return widget.child;
  }
}
