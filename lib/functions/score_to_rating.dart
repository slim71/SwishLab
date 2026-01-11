/// Express a rating related to the provided score
String scoreToRating(double? score) {
  if (score == null) {
    return 'MISSING';
  }

  if (score >= 1.0) {
    return 'PERFECT';
  } else if (score >= 0.75) {
    return 'EXCELLENT';
  } else if (score >= 0.5) {
    return 'GOOD';
  } else if (score >= 0.25) {
    return 'FAIR';
  } else {
    return 'POOR';
  }
}
