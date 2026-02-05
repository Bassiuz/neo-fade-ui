import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../theme/neo_fade_spacing.dart';
import '../../utils/animation_utils.dart';
import 'neo_tooltip_bubble.dart';

/// Glass tooltip with gradient pointer.
///
/// A tooltip that appears on hover or long press, featuring the Neo Fade
/// glass effect with a gradient-styled pointer.
class NeoTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final NeoTooltipPosition position;
  final Duration showDuration;
  final Duration waitDuration;

  const NeoTooltip({
    super.key,
    required this.child,
    required this.message,
    this.position = NeoTooltipPosition.bottom,
    this.showDuration = const Duration(seconds: 2),
    this.waitDuration = const Duration(milliseconds: 500),
  });

  @override
  State<NeoTooltip> createState() => NeoTooltipState();
}

class NeoTooltipState extends State<NeoTooltip>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  bool _isHovered = false;
  bool _isLongPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: NeoFadeAnimations.fast,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hideTooltip();
    _controller.dispose();
    super.dispose();
  }

  void _showTooltip() {
    if (_overlayEntry != null) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();

    Future.delayed(widget.showDuration, () {
      if (!_isHovered && !_isLongPressed) {
        _hideTooltip();
      }
    });
  }

  void _hideTooltip() {
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  void _onEnter(PointerEnterEvent event) {
    _isHovered = true;
    Future.delayed(widget.waitDuration, () {
      if (_isHovered && mounted) {
        _showTooltip();
      }
    });
  }

  void _onExit(PointerExitEvent event) {
    _isHovered = false;
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_isHovered && !_isLongPressed) {
        _hideTooltip();
      }
    });
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _isLongPressed = true;
    _showTooltip();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _isLongPressed = false;
    Future.delayed(widget.showDuration, () {
      if (!_isHovered && !_isLongPressed) {
        _hideTooltip();
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    Offset offset;
    Alignment alignment;

    switch (widget.position) {
      case NeoTooltipPosition.top:
        offset = Offset(size.width / 2, -NeoFadeSpacing.sm);
        alignment = Alignment.bottomCenter;
      case NeoTooltipPosition.bottom:
        offset = Offset(size.width / 2, size.height + NeoFadeSpacing.sm);
        alignment = Alignment.topCenter;
      case NeoTooltipPosition.left:
        offset = Offset(-NeoFadeSpacing.sm, size.height / 2);
        alignment = Alignment.centerRight;
      case NeoTooltipPosition.right:
        offset = Offset(size.width + NeoFadeSpacing.sm, size.height / 2);
        alignment = Alignment.centerLeft;
    }

    return OverlayEntry(
      builder: (context) => Positioned(
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: offset,
          targetAnchor: Alignment.topLeft,
          followerAnchor: alignment,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _controller,
                child: Transform.scale(
                  scale: 0.9 + (_controller.value * 0.1),
                  child: child,
                ),
              );
            },
            child: NeoTooltipBubble(
              message: widget.message,
              position: widget.position,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: _onEnter,
        onExit: _onExit,
        child: GestureDetector(
          onLongPressStart: _onLongPressStart,
          onLongPressEnd: _onLongPressEnd,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Position of the tooltip relative to its target.
enum NeoTooltipPosition {
  top,
  bottom,
  left,
  right,
}
