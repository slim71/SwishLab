import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/functions/is_field_valid.dart';

void main() {
  group('isFieldValid', () {
    test('should return true if field matches pattern', () {
      expect(isFieldValid('test@example.com', r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'), true);
      expect(isFieldValid('12345', r'^\d+$'), true);
    });

    test('should return false if field does not match pattern', () {
      expect(isFieldValid('not-an-email', r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'), false);
      expect(isFieldValid('abc', r'^\d+$'), false);
    });
  });
}
