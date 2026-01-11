import 'package:SwishLab/functions/get_section_name.dart';
import 'package:SwishLab/functions/process_fields.dart';
import 'package:SwishLab/functions/process_scores.dart';

/// Process the results JSON to extract relevant info
List<dynamic> processAnalysisResults(dynamic analysisResults) {
  return analysisResults.entries.map((entry) {
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
          {"name": getSectionName(sectionName), "value": sectionData}
        ],
        "scores": [],
      };
    }
  }).toList();
}
