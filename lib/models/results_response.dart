class AnalysisResults {
  final Map<String, dynamic> raw;

  AnalysisResults(this.raw);

  bool get succeeded => raw['success'] == true || raw['status'] == 'completed';

  Map<String, dynamic>? get analysis => raw['analysis'] as Map<String, dynamic>?;

  String? get error => raw['error'] as String?;
}
