import 'package:flutter/material.dart';

import '../styles/theme_manager.dart';

class SocialIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;

  final double size;
  final double iconSize;
  final double borderRadius;
  final double borderWidth;

  const SocialIconButton(
    this.icon, {
    super.key,
    required this.onTap,
    this.size = 48,
    this.iconSize = 24,
    this.borderRadius = 12,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppThemeManager.notifier,
        builder: (_, __, ___) {
          return Container(
              color: AppThemeManager.primaryBackground,
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: onTap,
                child: Ink(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: AppThemeManager.primaryBackground,
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      color: AppThemeManager.secondaryBackground,
                      width: borderWidth,
                    ),
                  ),
                  child: Center(
                    child: icon,
                  ),
                ),
              ));
        });
  }
}
