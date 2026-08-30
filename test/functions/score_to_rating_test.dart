import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/functions/score_to_rating.dart';

void main() {
  group('scoreToRating', () {
    test('should return MISSING for null', () {
      expect(scoreToRating(null), 'MISSING');
    });

    test('should return PERFECT for score >= 1.0', () {
      expect(scoreToRating(1.0), 'PERFECT');
      expect(scoreToRating(1.5), 'PERFECT');
    });

    test('should return EXCELLENT for score >= 0.75', () {
      expect(scoreToRating(0.75), 'EXCELLENT');
      expect(scoreToRating(0.99), 'EXCELLENT');
    });

    test('should return GOOD for score >= 0.5', () {
      expect(scoreToRating(0.5), 'GOOD');
      expect(scoreToRating(0.74), 'GOOD');
    });

    test('should return FAIR for score >= 0.25', () {
      expect(scoreToRating(0.25), 'FAIR');
      expect(scoreToRating(0.49), 'FAIR');
    });

    test('should return POOR for score < 0.25', () {
      expect(scoreToRating(0.0), 'POOR');
      expect(scoreToRating(0.24), 'POOR');
    });
  });
}
