import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/functions/process_scores.dart';

void main() {
  group('processScores', () {
    test('should return empty list if scores key missing', () {
      expect(processScores(<String, dynamic>{'data': 1}), <dynamic>[]);
    });

    test('should return empty list if scores not a map', () {
      expect(processScores(<String, dynamic>{'scores': 'invalid'}), <dynamic>[]);
    });

    test('should extract scores with section names', () {
      final input = {
        'scores': {
          'total': 0.9,
          'ball_eye_distance': 0.8,
        }
      };
      final result = processScores(input);
      expect(result.length, 2);
      expect(result[0], <String, dynamic>{'name': 'Total', 'value': 0.9});
      expect(result[1], <String, dynamic>{'name': 'Ball eye distance', 'value': 0.8});
    });
  });
}
