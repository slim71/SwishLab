import 'package:flutter/material.dart';

import '../styles/theme_manager.dart';

class SocialIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;

  final double size;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final Color? backgroundColor;

  const SocialIconButton(
    this.icon, {
    super.key,
    required this.onTap,
    this.size = 48,
    this.borderRadius = 12,
    this.borderWidth = 1.5,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppThemeManager.notifier,
        builder: (_, __, ___) {
          final effectiveBorderColor = borderColor ?? AppThemeManager.secondaryBackground;
          final effectiveBackgroundColor =
              backgroundColor ?? AppThemeManager.secondaryBackground.withValues(alpha: 0.3);

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(borderRadius),
              onTap: onTap,
              child: Ink(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: effectiveBackgroundColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: effectiveBorderColor,
                    width: borderWidth,
                  ),
                ),
                child: Center(
                  child: icon,
                ),
              ),
            ),
          );
        });
  }
}
