import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:SwishLab/styles/theme_manager.dart';

class SocialIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  final double size;
  final double iconSize;
  final double borderRadius;
  final double borderWidth;

  const SocialIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 48,
    this.iconSize = 24,
    this.borderRadius = 12,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onTap,
      child: Ink(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: appColors.primaryBackground,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: appColors.secondaryBackground,
            width: borderWidth,
          ),
        ),
        child: Center(
          child: FaIcon(
            icon,
            size: iconSize,
            color: appColors.secondaryText,
          ),
        ),
      ),
    );
  }
}
