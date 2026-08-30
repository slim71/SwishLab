import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/functions/shadow_from_color.dart';

void main() {
  group('shadowFromColor', () {
    test('should return a darker version of the color with opacity', () {
      const color = Color(0xFFFF0000); // Red
      final shadow = shadowFromColor(color, opacity: 0.5);

      expect((shadow.a * 255).round(), (0.5 * 255).round());
      // HSL lightness of Red is 0.5. Shadow should be 0.5 - 0.15 = 0.35.
      final hsl = HSLColor.fromColor(shadow.withAlpha(255));
      expect(hsl.lightness, closeTo(0.35, 0.01));
    });

    test('should clamp lightness to 0.0', () {
      const color = Color(0xFF000000); // Black
      final shadow = shadowFromColor(color);

      final hsl = HSLColor.fromColor(shadow.withAlpha(255));
      expect(hsl.lightness, 0.0);
    });

    test('should respect default opacity', () {
      const color = Color(0xFFFFFFFF);
      final shadow = shadowFromColor(color);
      expect((shadow.a * 255).round(), (0.25 * 255).round());
    });
  });
}
