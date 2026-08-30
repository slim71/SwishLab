import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppTransition {
  none,
  fade,
  bottomToTop,
  topToBottom,
  rightToLeft,
  leftToRight,
}

CustomTransitionPage<T> buildTransitionPage<T>({
  required GoRouterState state,
  required Widget child,
  AppTransition transition = AppTransition.none,
  Duration duration = const Duration(milliseconds: 300),
  Curve curve = Curves.easeOut,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: transition == AppTransition.none ? Duration.zero : duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      switch (transition) {
        case AppTransition.none:
          return child;

        case AppTransition.fade:
          return FadeTransition(
            opacity: curvedAnimation,
            child: child,
          );

        case AppTransition.bottomToTop:
          return SlideTransition(
            position: curvedAnimation.drive(
              Tween(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ),
            ),
            child: child,
          );

        case AppTransition.topToBottom:
          return SlideTransition(
            position: curvedAnimation.drive(
              Tween(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ),
            ),
            child: child,
          );

        case AppTransition.rightToLeft:
          return SlideTransition(
            position: curvedAnimation.drive(
              Tween(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ),
            ),
            child: child,
          );

        case AppTransition.leftToRight:
          return SlideTransition(
            position: curvedAnimation.drive(
              Tween(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ),
            ),
            child: child,
          );
      }
    },
  );
}
