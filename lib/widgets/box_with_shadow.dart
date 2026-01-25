import 'package:SwishLab/functions/shadow_from_color.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:flutter/material.dart';

class BoxWithShadow extends BoxDecoration {
  BoxWithShadow({
    super.gradient,
    Color? color,
    super.shape,
    BorderRadius? borderRadius,
    super.border,
    Offset shadowOffset = const Offset(0, 10),
    double blurRadius = 5,
    double spreadRadius = 3,
    Color? shadowColor,
  }) : super(
          color: color ?? AppThemeManager.currentColors.secondaryBackground,
          borderRadius: shape == BoxShape.rectangle ? (borderRadius ?? _defaultBorderRadius) : null,
          boxShadow: [
            BoxShadow(
              offset: shadowOffset,
              blurRadius: blurRadius,
              spreadRadius: spreadRadius,
              color: shadowFromColor(color ?? AppThemeManager.currentColors.secondaryBackground),
            ),
          ],
        );

  static final BorderRadius _defaultBorderRadius = BorderRadius.circular(12);
}
