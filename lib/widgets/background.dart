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
      decoration: BoxDecoration(
        gradient: appColors.gradientBackground(),
      ),
      child: child,
    );
  }
}
