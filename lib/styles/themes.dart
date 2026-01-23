import 'package:flutter/material.dart';

import 'colors.dart';

// Dynamically build a theme based on the provided brightness and color set
ThemeData buildTheme(AppColorSet colors, Brightness brightness) {
  final baseTextTheme = brightness == Brightness.dark
      ? ThemeData.dark().textTheme
      : ThemeData.light().textTheme;

  final scheme = ColorScheme.fromSeed(
    seedColor: colors.primaryOne,
    brightness: brightness,
  );
  const splashAlpha = 0.12;
  const highlightAlpha = 0.08;
  const hoverAlpha = 0.04;

  return ThemeData(
    brightness: brightness,
    colorScheme: scheme,
    splashFactory: InkRipple.splashFactory,
    splashColor: colors.primaryOne.withValues(alpha: splashAlpha),
    highlightColor: colors.primaryOne.withValues(alpha: highlightAlpha),
    hoverColor: colors.primaryOne.withValues(alpha: hoverAlpha),
    focusColor: colors.primaryOne.withValues(alpha: splashAlpha),
    textTheme: baseTextTheme.copyWith(
      bodyMedium: TextStyle(
        color: brightness == Brightness.dark
            ? colors.alternateTwo
            : colors.primaryTwo,
      ),
    ),
    extensions: [colors],
  );
}
