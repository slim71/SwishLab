import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/functions/get_section_name.dart';

void main() {
  group('getSectionName', () {
    test('should convert snake_case to Normal Case', () {
      expect(getSectionName('set_point'), 'Set point');
      expect(getSectionName('jump'), 'Jump');
      expect(getSectionName('elbow_position'), 'Elbow position');
      expect(getSectionName('feet_direction'), 'Feet direction');
      expect(getSectionName('shot_path'), 'Shot path');
      expect(getSectionName('follow_through'), 'Follow through');
    });

    test('should handle single word', () {
      expect(getSectionName('test'), 'Test');
    });

    test('should handle multiple underscores', () {
      expect(getSectionName('this_is_a_test'), 'This is a test');
    });

    test('should handle empty string', () {
      // The implementation does:
      // final words = section.split('_').map((w) => w.toLowerCase()).toList();
      // if (words.isEmpty) return "";
      // words.first[0] ...
      // Split on empty string returns ['']
      expect(getSectionName(''), '');
    });

    test('should handle string starting with underscore', () {
      expect(getSectionName('_test'), '');
    });
  });
}
