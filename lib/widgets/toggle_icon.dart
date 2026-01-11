import 'package:flutter/material.dart';

class ToggleIcon extends StatelessWidget {
  final bool value;
  final Widget onIcon;
  final Widget offIcon;
  final VoidCallback onPressed;
  final Duration duration;

  const ToggleIcon({
    super.key,
    required this.value,
    required this.onIcon,
    required this.offIcon,
    required this.onPressed,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: AnimatedSwitcher(
        duration: duration,
        switchInCurve: Curves.easeOutBack,
        // bounce in
        switchOutCurve: Curves.easeIn,
        // switchInCurve: Curves.elasticOut // stronger
        transitionBuilder: (child, animation) {
          // Rotation: 180° → 0°
          final rotate = Tween<double>(
            begin: 0.75, //0.0 for more rotation
            end: 1.0,
          ).animate(animation);

          // Bounce / scale overshoot
          final scale = Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(animation);

          return RotationTransition(
            turns: rotate,
            child: ScaleTransition(
              scale: scale,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(value),
          child: value ? onIcon : offIcon,
        ),
      ),
    );
  }
}
