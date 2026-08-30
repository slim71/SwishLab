import 'analysis_data.dart';

class ResultsResponse {
  final Map<String, dynamic> raw;
  final bool opStatus;
  final String? opError;

  ResultsResponse(this.raw, {this.opStatus = true, this.opError});

  bool get succeeded => opStatus;

  Map<String, dynamic>? get _analysisRaw => raw['analysis'] as Map<String, dynamic>?;

  /// Legacy getter for raw analysis data (for tests and backwards compatibility)
  Map<String, dynamic>? get analysis => _analysisRaw;

  SetPointData? get setPoint => _analysisRaw?['set_point'] != null
      ? SetPointData.fromJson(_analysisRaw!['set_point'] as Map<String, dynamic>)
      : null;

  JumpData? get jump =>
      _analysisRaw?['jump'] != null ? JumpData.fromJson(_analysisRaw!['jump'] as Map<String, dynamic>) : null;

  ElbowPositionData? get elbowPosition => _analysisRaw?['elbow_position'] != null
      ? ElbowPositionData.fromJson(_analysisRaw!['elbow_position'] as Map<String, dynamic>)
      : null;

  FeetDirectionData? get feetDirection => _analysisRaw?['feet_direction'] != null
      ? FeetDirectionData.fromJson(_analysisRaw!['feet_direction'] as Map<String, dynamic>)
      : null;

  ShotPathData? get shotPath => _analysisRaw?['shot_path'] != null
      ? ShotPathData.fromJson(_analysisRaw!['shot_path'] as Map<String, dynamic>)
      : null;

  FollowThroughData? get followThrough => _analysisRaw?['follow_through'] != null
      ? FollowThroughData.fromJson(_analysisRaw!['follow_through'] as Map<String, dynamic>)
      : null;

  String? get error => opError;
}
