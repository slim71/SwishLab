import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../logger.dart';
import '../functions/load_json_remote_or_app_state.dart';

final _logger = AppLogger.scope('FeedbackProvider');

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
    Map<String, dynamic>? section;
    for (var s in templates) {
      if (s['section'].toString().toLowerCase() == sectionName.toLowerCase()) {
        section = s;
        break;
      }
    }
    section ??= <String, dynamic>{};

    if (section.isEmpty) {
      _logger.w('Feedback section not found: $sectionName');
      return 'Great work on your $sectionName!';
    }

    // 2. Find the score category within that section
    final scores = (section['scores'] as List? ?? <dynamic>[]);
    Map<String, dynamic>? scoreConfig;
    for (var sc in scores) {
      if (sc is Map && sc['name'].toString().toLowerCase() == scoreName.toLowerCase()) {
        scoreConfig = sc.cast<String, dynamic>();
        break;
      }
    }
    if (scoreConfig == null) {
      for (var sc in scores) {
        if (sc is Map && sc['name'].toString().toLowerCase() == 'total') {
          scoreConfig = sc.cast<String, dynamic>();
          break;
        }
      }
    }

    if (scoreConfig == null) {
      _logger.w('Feedback score config not found for $scoreName in $sectionName');
      return 'Keep practicing your $sectionName $scoreName!';
    }

    // 3. Find the matching range
    final ranges = (scoreConfig['ranges'] as List? ?? <dynamic>[]);
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
