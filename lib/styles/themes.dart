import 'package:flutter/material.dart';
import 'package:swish_lab/styles/theme_manager.dart';

// Dynamically build a theme
ThemeData buildTheme() {
  final colors = AppThemeManager.currentColors;
  final isDark = AppThemeManager.isDark;
  final baseTextTheme = isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;

  final scheme = ColorScheme.fromSeed(
    seedColor: colors.primaryOne,
    brightness: isDark ? Brightness.dark : Brightness.light,
  );
  const splashAlpha = 0.12;
  const highlightAlpha = 0.08;
  const hoverAlpha = 0.04;

  return ThemeData(
    brightness: isDark ? Brightness.dark : Brightness.light,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppThemeManager.primaryBackground,
    canvasColor: AppThemeManager.primaryBackground,
    splashFactory: InkRipple.splashFactory,
    splashColor: colors.primaryOne.withValues(alpha: splashAlpha),
    highlightColor: colors.primaryOne.withValues(alpha: highlightAlpha),
    hoverColor: colors.primaryOne.withValues(alpha: hoverAlpha),
    focusColor: colors.primaryOne.withValues(alpha: splashAlpha),
    textTheme: baseTextTheme.copyWith(
      bodyMedium: TextStyle(
        color: isDark ? colors.alternateTwo : colors.primaryTwo,
      ),
    ),
    extensions: [colors],
  );
}
