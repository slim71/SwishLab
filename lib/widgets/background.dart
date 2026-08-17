import 'package:flutter/cupertino.dart';

import '../styles/theme_manager.dart';

class Background extends StatelessWidget {
  const Background({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: appColors.gradientBackground(),
      ),
      child: child,
    );
  }
}
