import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../functions/load_json_remote_or_app_state.dart';

/// Provider that loads coaching feedback templates from Supabase or local fallback.
final feedbackProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return loadJsonRemoteOrAppState('feedback_strings', kDefaultFeedbackJson);
});

/// Helper to find the correct feedback string based on section, score name, and value.
String getFeedbackForScore({
  required List<Map<String, dynamic>> templates,
  required String sectionName,
  required String scoreName,
  required double scoreValue,
}) {
  try {
    // 1. Find the section
    final section = templates.firstWhere(
      (s) => s['section'].toString().toLowerCase() == sectionName.toLowerCase(),
      orElse: () => <String, dynamic>{},
    );

    if (section.isEmpty) return 'Great work on your $sectionName!';

    // 2. Find the score category within that section
    final scores = (section['scores'] as List? ?? []);
    final scoreConfig = scores.firstWhere(
      (sc) => sc['name'].toString().toLowerCase() == scoreName.toLowerCase(),
      orElse: () => scores.firstWhere((sc) => sc['name'].toString().toLowerCase() == 'total', orElse: () => null),
    );

    if (scoreConfig == null) return 'Keep practicing your $sectionName $scoreName!';

    // 3. Find the matching range
    final ranges = (scoreConfig['ranges'] as List? ?? []);
    for (var range in ranges) {
      final double min = (range['min'] as num).toDouble();
      final double max = (range['max'] as num).toDouble();

      if (scoreValue >= min && scoreValue <= max) {
        return range['feedback'].toString();
      }
    }

    return 'Analysis complete for $sectionName.';
  } catch (e) {
    return 'Keep up the good work on your $sectionName!';
  }
}
