import 'get_section_name.dart';
import 'process_fields.dart';
import 'process_scores.dart';

/// Process the results JSON to extract relevant info
List<dynamic> processAnalysisResults(Map<String, dynamic> analysisResults) {
  return analysisResults.entries.map<Map<String, dynamic>>((entry) {
    final sectionName = entry.key;
    final sectionData = entry.value;

    if (sectionData is Map<String, dynamic>) {
      return {
        "section": getSectionName(sectionName),
        "fields": processFields(sectionData),
        "scores": processScores(sectionData),
      };
    } else {
      return {
        "section": getSectionName(sectionName),
        "fields": [
          <String, dynamic>{"name": getSectionName(sectionName), "value": sectionData}
        ],
        "scores": <Map<String, dynamic>>[],
      };
    }
  }).toList();
}
