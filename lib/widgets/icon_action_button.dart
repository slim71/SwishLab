import 'package:flutter/material.dart';
import 'package:swish_lab/styles/theme_manager.dart';

class IconActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final double borderRadius;
  final double borderWidth;
  final Color? iconColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final BoxShape shape;
  final bool wrapped;

  const IconActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 50,
    this.iconSize = 30,
    this.borderRadius = 30,
    this.borderWidth = 1,
    this.shape = BoxShape.circle,
    this.iconColor,
    this.backgroundColor = Colors.transparent,
    this.padding = const EdgeInsets.all(0),
    this.alignment = Alignment.center,
    this.wrapped = false,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppThemeManager.notifier,
        builder: (_, __, ___) {
          final appColors = AppThemeManager.currentColors;

          return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: shape,
                  border: wrapped
                      ? Border.all(
                      color: appColors.actionButtonBorders,
                      width: borderWidth,
                        )
                      : null,
                ),
                child: IconButton(
                  onPressed: onPressed,
                  iconSize: iconSize,
                  color: iconColor ?? AppThemeManager.primaryText,
                  icon: Icon(icon),
                  padding: padding,
                  alignment: alignment,
                  splashRadius: size / 2,
                ),
          );
        });
  }
}
