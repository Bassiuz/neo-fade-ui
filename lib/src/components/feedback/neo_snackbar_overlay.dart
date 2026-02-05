import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_spacing.dart';
import '../../utils/animation_utils.dart';
import 'neo_snackbar.dart';

/// Overlay wrapper for NeoSnackbar with entrance/exit animations.
class NeoSnackbarOverlay extends StatefulWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final NeoSnackbarType type;
  final Duration duration;
  final VoidCallback onDismiss;

  const NeoSnackbarOverlay({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<NeoSnackbarOverlay> createState() => NeoSnackbarOverlayState();
}

class NeoSnackbarOverlayState extends State<NeoSnackbarOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.normal,
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: NeoFadeAnimations.defaultCurve,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: NeoFadeAnimations.defaultCurve,
    ));

    _controller.forward();

    Future.delayed(widget.duration, _dismiss);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (!mounted) return;
    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: NeoFadeSpacing.lg,
      right: NeoFadeSpacing.lg,
      bottom: NeoFadeSpacing.xl,
      child: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: NeoSnackbar(
              message: widget.message,
              actionLabel: widget.actionLabel,
              onAction: widget.onAction,
              type: widget.type,
              onDismiss: _dismiss,
            ),
          ),
        ),
      ),
    );
  }
}
