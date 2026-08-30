import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/functions/process_analysis_results.dart';

void main() {
  group('processAnalysisResults', () {
    test('should process sections correctly', () {
      final input = {
        'set_point': {
          'ball_eye_distance': 1.0,
          'scores': {'total': 0.9}
        }
      };
      final result = processAnalysisResults(input);
      expect(result.length, 1);
      expect(result[0]['section'], 'Set point');
      expect(result[0]['fields'], isList);
      expect(result[0]['scores'], isList);
    });

    test('should handle non-map section data', () {
      final input = {'status': 'complete'};
      final result = processAnalysisResults(input);
      expect(result[0]['section'], 'Status');
      expect(result[0]['fields'][0]['value'], 'complete');
      expect(result[0]['scores'], <dynamic>[]);
    });
  });
}
