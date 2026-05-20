class ResultsResponse {
  final Map<String, dynamic> raw;
  final bool opStatus;
  final String? opError;

  ResultsResponse(this.raw, {this.opStatus = true, this.opError});

  bool get succeeded => opStatus;

  Map<String, dynamic>? get analysis => raw['analysis'] as Map<String, dynamic>?;

  String? get error => opError;
}
