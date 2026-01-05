import 'package:flutter/material.dart';

class IconActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
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
    this.iconSize = 30, //TODO: 24?
    this.borderRadius = 30,
    this.borderWidth = 1,
    this.borderColor = Colors.transparent,
    this.shape = BoxShape.circle,
    this.iconColor,
    this.backgroundColor = Colors.transparent,
    this.padding = const EdgeInsets.all(0),
    this.alignment = Alignment.center,
    this.wrapped = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: shape,
        border: wrapped
            ? Border.all(
                color: borderColor,
                width: borderWidth,
              )
            : null,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
        padding: padding,
        alignment: alignment,
        splashRadius: size / 2,
      ),
    );
  }
}
