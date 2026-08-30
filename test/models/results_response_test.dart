import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/models/results_response.dart';

void main() {
  group('ResultsResponse', () {
    test('succeeded returns true by default', () {
      final response = ResultsResponse(<String, dynamic>{});
      expect(response.succeeded, isTrue);
      expect(response.analysis, isNull);
    });

    test('getters return correct section data', () {
      final json = <String, dynamic>{
        'analysis': <String, dynamic>{
          'set_point': <String, dynamic>{
            'ball_eye_distance': 1.0,
            'scores': <String, dynamic>{'total': 80}
          },
          'jump': <String, dynamic>{
            'phase': 0.5,
            'scores': <String, dynamic>{'total': 70}
          },
          'elbow_position': <String, dynamic>{
            'vertical': 10,
            'scores': <String, dynamic>{'total': 90}
          },
          'feet_direction': <String, dynamic>{
            'left_direction': 1,
            'scores': <String, dynamic>{'total': 80}
          },
          'shot_path': <String, dynamic>{
            'average_deviation': 1,
            'scores': <String, dynamic>{'total': 95}
          },
          'follow_through': <String, dynamic>{
            'held': true,
            'scores': <String, dynamic>{'total': 88}
          },
        }
      };
      final response = ResultsResponse(json);

      expect(response.setPoint?.totalScore, 80);
      expect(response.jump?.totalScore, 70);
      expect(response.elbowPosition?.totalScore, 90);
      expect(response.feetDirection?.totalScore, 80);
      expect(response.shotPath?.totalScore, 95);
      expect(response.followThrough?.totalScore, 88);
    });

    test('error returns opError', () {
      final response = ResultsResponse(<String, dynamic>{}, opStatus: false, opError: 'Failed');
      expect(response.succeeded, isFalse);
      expect(response.error, 'Failed');
    });

    test('getters return null if section missing', () {
      final response = ResultsResponse(<String, dynamic>{'analysis': <String, dynamic>{}});
      expect(response.setPoint, isNull);
      expect(response.jump, isNull);
      expect(response.elbowPosition, isNull);
      expect(response.feetDirection, isNull);
      expect(response.shotPath, isNull);
      expect(response.followThrough, isNull);
    });
  });
}
