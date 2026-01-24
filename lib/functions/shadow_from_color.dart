import 'package:flutter/cupertino.dart';

Color shadowFromColor(Color color, {double opacity = 0.25}) {
  final hsl = HSLColor.fromColor(color);
  final darker = hsl.withLightness(
    (hsl.lightness - 0.15).clamp(0.0, 1.0),
  );
  final c = darker.toColor();
  return c.withAlpha((opacity * 255).round());
}
