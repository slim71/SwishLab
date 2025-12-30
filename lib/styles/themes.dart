import 'package:flutter/material.dart';

import 'colors.dart';

// Dynamically build a theme based on the provided brightness and color set
ThemeData buildTheme(AppColorSet colors, Brightness brightness) {
  final baseTextTheme = brightness == Brightness.dark
      ? ThemeData.dark().textTheme
      : ThemeData.light().textTheme;

  return ThemeData(
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: colors.primaryOne,
      brightness: brightness,
    ),
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
