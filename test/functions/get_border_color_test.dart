import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/functions/get_border_color.dart';

void main() {
  group('getBorderColor', () {
    test('should return black if colors list is empty', () {
      expect(getBorderColor(<Color>[], 0), Colors.black);
    });

    test('should return color at index', () {
      final colors = [Colors.red, Colors.green, Colors.blue];
      expect(getBorderColor(colors, 0), Colors.red);
      expect(getBorderColor(colors, 1), Colors.green);
      expect(getBorderColor(colors, 2), Colors.blue);
    });

    test('should wrap around index using modulo', () {
      final colors = [Colors.red, Colors.green, Colors.blue];
      expect(getBorderColor(colors, 3), Colors.red);
      expect(getBorderColor(colors, 4), Colors.green);
      expect(getBorderColor(colors, 5), Colors.blue);
    });
  });
}
