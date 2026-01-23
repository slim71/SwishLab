import 'package:SwishLab/styles/theme_manager.dart';
import 'package:flutter/cupertino.dart';

class Background extends StatelessWidget {
  const Background({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: appColors.gradientBackground(),
      ),
      child: child,
    );
  }
}
