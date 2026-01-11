import 'package:flutter/material.dart';

Color getBorderColor(
  List<Color> colors,
  int index,
) {
  if (colors.isEmpty) return Colors.black;
  return colors[index % colors.length];
}
