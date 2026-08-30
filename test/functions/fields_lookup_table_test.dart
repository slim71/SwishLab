import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/functions/fields_lookup_table.dart';

void main() {
  group('fieldsLookupTable', () {
    test('should return correct info for existing keys', () {
      expect(fieldsLookupTable('ball_eye_distance'), {"unit": "px"});
      expect(fieldsLookupTable('elbow_angle'), {
        "unit": "°",
        "range": {"min": 30, "max": 180}
      });
      expect(fieldsLookupTable('efficiency'), {
        "unit": "%",
        "range": {"min": 0, "max": 100}
      });
    });

    test('should return null for non-existing keys', () {
      expect(fieldsLookupTable('non_existing_key'), isNull);
    });

    test('should return correct info for all documented keys', () {
      final keys = [
        "ball_eye_distance",
        "elbow_angle",
        "shoulder_angle",
        "phase",
        "forward_distance",
        "side_distance",
        "vertical",
        "horizontal",
        "left_direction",
        "right_direction",
        "left_angle",
        "right_angle",
        "average_wrist_angle",
        "average_deviation",
        "max_deviation",
        "deviation_ratio",
        "efficiency",
        "angle_variance",
        "held",
        "frames_held",
        "final_elbow_angle",
        "average_wrist_velocity",
        "average_finger_velocity",
      ];
      for (final key in keys) {
        expect(fieldsLookupTable(key), isNotNull, reason: 'Key $key should exist');
      }
    });
  });
}
