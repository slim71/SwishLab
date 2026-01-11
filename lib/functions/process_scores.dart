import 'package:SwishLab/functions/get_section_name.dart';

/// Process the "scores" subsection of the results JSON to extract relevant
/// info
List<dynamic> processScores(dynamic data) {
  if (!data.containsKey("scores") || data["scores"] is! Map<String, dynamic>) {
    return [];
  }
  final scores = data["scores"] as Map<String, dynamic>;
  return scores.entries.map((entry) {
    return {
      "name": getSectionName(entry.key),
      "value": entry.value,
    };
  }).toList();
}
