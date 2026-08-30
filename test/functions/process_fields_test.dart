import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/functions/process_fields.dart';

void main() {
  group('processFields', () {
    test('should filter out scores key', () {
      final input = {
        'field1': 10,
        'scores': {'s1': 1},
      };
      final result = processFields(input);
      expect(result.length, 1);
      expect(result[0]['name'], 'Field1');
    });

    test('should add unit and range from metadata', () {
      final input = {
        'elbow_angle': 90,
      };
      final result = processFields(input);
      expect(result[0]['unit'], '°');
      expect(result[0]['range'], '[30-180]');
    });

    test('should handle nested maps', () {
      final input = {
        'nested': {
          'sub_field': 5,
        }
      };
      final result = processFields(input);
      expect(result[0]['name'], 'Nested');
      expect(result[0]['value'], isList);
      expect(result[0]['value'][0]['name'], 'Sub field');
    });

    test('should add only unit if range is missing in metadata', () {
      final input = {
        'ball_eye_distance': 50,
      };
      final result = processFields(input);
      expect(result[0]['unit'], 'px');
      expect(result[0].containsKey('range'), false);
    });

    test('should work if no metadata is found', () {
      final input = {
        'unknown_field': 100,
      };
      final result = processFields(input);
      expect(result[0]['name'], 'Unknown field');
      expect(result[0].containsKey('unit'), false);
      expect(result[0].containsKey('range'), false);
    });
  });
}
