class AnalysisResponse {
  final String eventId;

  AnalysisResponse({required this.eventId});

  factory AnalysisResponse.fromJson(Map<String, dynamic> json) {
    return AnalysisResponse(
      eventId: json['event_id'],
    );
  }
}
