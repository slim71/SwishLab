import 'package:flutter/material.dart';
import 'package:swish_lab/functions/shadow_from_color.dart';
import 'package:swish_lab/styles/theme_manager.dart';

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
          color: color ?? AppThemeManager.primaryBackground,
          borderRadius: shape == BoxShape.rectangle ? (borderRadius ?? _defaultBorderRadius) : null,
          boxShadow: [
            BoxShadow(
              offset: shadowOffset,
              blurRadius: blurRadius,
              spreadRadius: spreadRadius,
              color: shadowFromColor(color ?? AppThemeManager.primaryBackground),
            ),
          ],
        );

  static final BorderRadius _defaultBorderRadius = BorderRadius.circular(12);
}
