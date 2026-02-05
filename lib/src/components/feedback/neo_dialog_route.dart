import 'package:flutter/widgets.dart';

import '../../utils/animation_utils.dart';

/// Route for showing NeoDialog with custom transition.
class NeoDialogRoute<T> extends PopupRoute<T> {
  final WidgetBuilder builder;
  final bool dismissible;

  NeoDialogRoute({
    required this.builder,
    this.dismissible = true,
  });

  @override
  Color? get barrierColor => const Color(0x80000000);

  @override
  bool get barrierDismissible => dismissible;

  @override
  String? get barrierLabel => 'Dismiss';

  @override
  Duration get transitionDuration => NeoFadeAnimations.normal;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: NeoFadeAnimations.defaultCurve,
      reverseCurve: NeoFadeAnimations.exitCurve,
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1.0).animate(curvedAnimation),
        child: child,
      ),
    );
  }
}
