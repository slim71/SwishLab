import '../constants.dart';

/// Express a rating related to the provided score using centralized thresholds
String scoreToRating(double? score) {
  if (score == null) {
    return 'MISSING';
  }

  if (score >= kScorePerfect) {
    return 'PERFECT';
  } else if (score >= kScoreExcellent) {
    return 'EXCELLENT';
  } else if (score >= kScoreGood) {
    return 'GOOD';
  } else if (score >= kScoreFair) {
    return 'FAIR';
  } else {
    return 'POOR';
  }
}
