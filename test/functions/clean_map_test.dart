import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/functions/clean_map.dart';

void main() {
  group('cleanMap', () {
    test('should remove null values from map', () {
      final input = {
        'a': 1,
        'b': null,
        'c': 'hello',
        'd': null,
      };
      final expected = {
        'a': 1,
        'c': 'hello',
      };
      expect(cleanMap(input), expected);
    });

    test('should return empty map if input is empty', () {
      final input = <String, dynamic>{};
      expect(cleanMap(input), <String, dynamic>{});
    });

    test('should return same map if no null values', () {
      final input = {
        'a': 1,
        'b': 2,
      };
      expect(cleanMap(input), input);
    });

    test('should return empty map if all values are null', () {
      final input = {
        'a': null,
        'b': null,
      };
      expect(cleanMap(input), <String, dynamic>{});
    });
  });
}
