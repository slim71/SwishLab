import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/functions/sort_by_order.dart';

void main() {
  group('sortByOrder', () {
    test('should sort list by order field', () {
      final input = [
        {'id': 1, 'order': 3},
        {'id': 2, 'order': 1},
        {'id': 3, 'order': 2},
      ];
      final result = sortByOrder(input);
      expect(result[0]['id'], 2);
      expect(result[1]['id'], 3);
      expect(result[2]['id'], 1);
    });

    test('should handle missing order field as 0', () {
      final input = [
        {'id': 1, 'order': 3},
        {'id': 2},
        {'id': 3, 'order': 2},
      ];
      final result = sortByOrder(input);
      expect(result[0]['id'], 2);
      expect(result[1]['id'], 3);
      expect(result[2]['id'], 1);
    });

    test('should not modify original list', () {
      final input = [
        {'order': 2},
        {'order': 1},
      ];
      sortByOrder(input);
      expect(input[0]['order'], 2);
    });

    test('should handle non-map items', () {
      final input = [
        {'order': 2},
        'not a map',
        {'order': 1},
      ];
      final result = sortByOrder(input);
      // 'not a map' treated as order 0
      expect(result[0], 'not a map');
      expect(result[1]['order'], 1);
      expect(result[2]['order'], 2);
    });

    test('should handle non-num order field as 0', () async {
      final input = [
        {'id': 1, 'order': 3},
        {'id': 2, 'order': 'one'},
        {'id': 3, 'order': 2},
      ];
      final result = sortByOrder(input);
      expect(result[0]['id'], 2);
      expect(result[1]['id'], 3);
      expect(result[2]['id'], 1);
    });
  });
}
