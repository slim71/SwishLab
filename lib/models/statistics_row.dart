class StatisticsRow {
  final String statId;
  final String userId;
  final DateTime createdAt;

  final double? setPointTotalScore;
  final double? jumpTotalScore;
  final double? elbowPositionTotalScore;
  final double? feetDirectionTotalScore;
  final double? shotPathTotalScore;
  final double? followThroughTotalScore;

  final Map<String, dynamic>? setPoint;
  final Map<String, dynamic>? jump;
  final Map<String, dynamic>? elbowPosition;
  final Map<String, dynamic>? feetDirection;
  final Map<String, dynamic>? shotPath;
  final Map<String, dynamic>? followThrough;

  const StatisticsRow({
    required this.statId, // primary key
    required this.userId,
    required this.createdAt,
    this.setPointTotalScore,
    this.jumpTotalScore,
    this.elbowPositionTotalScore,
    this.feetDirectionTotalScore,
    this.shotPathTotalScore,
    this.followThroughTotalScore,
    this.setPoint,
    this.jump,
    this.elbowPosition,
    this.feetDirection,
    this.shotPath,
    this.followThrough,
  });

  factory StatisticsRow.fromJson(Map<String, dynamic> json) {
    return StatisticsRow(
      statId: json['stat_id'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      setPointTotalScore: (json['set_point_total_score'] as num?)?.toDouble(),
      jumpTotalScore: (json['jump_total_score'] as num?)?.toDouble(),
      elbowPositionTotalScore:
          (json['elbow_position_total_score'] as num?)?.toDouble(),
      feetDirectionTotalScore:
          (json['feet_direction_total_score'] as num?)?.toDouble(),
      shotPathTotalScore: (json['shot_path_total_score'] as num?)?.toDouble(),
      followThroughTotalScore:
          (json['follow_through_total_score'] as num?)?.toDouble(),
      setPoint: json['set_point'] as Map<String, dynamic>?,
      jump: json['jump'] as Map<String, dynamic>?,
      elbowPosition: json['elbow_position'] as Map<String, dynamic>?,
      feetDirection: json['feet_direction'] as Map<String, dynamic>?,
      shotPath: json['shot_path'] as Map<String, dynamic>?,
      followThrough: json['follow_through'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stat_id': statId,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'set_point_total_score': setPointTotalScore,
      'jump_total_score': jumpTotalScore,
      'elbow_position_total_score': elbowPositionTotalScore,
      'feet_direction_total_score': feetDirectionTotalScore,
      'shot_path_total_score': shotPathTotalScore,
      'follow_through_total_score': followThroughTotalScore,
      'set_point': setPoint,
      'jump': jump,
      'elbow_position': elbowPosition,
      'feet_direction': feetDirection,
      'shot_path': shotPath,
      'follow_through': followThrough,
    };
  }

  StatisticsRow copyWith({
    String? statId,
    String? userId,
    DateTime? createdAt,
    double? setPointTotalScore,
    double? jumpTotalScore,
    double? elbowPositionTotalScore,
    double? feetDirectionTotalScore,
    double? shotPathTotalScore,
    double? followThroughTotalScore,
    Map<String, dynamic>? setPoint,
    Map<String, dynamic>? jump,
    Map<String, dynamic>? elbowPosition,
    Map<String, dynamic>? feetDirection,
    Map<String, dynamic>? shotPath,
    Map<String, dynamic>? followThrough,
  }) {
    return StatisticsRow(
      statId: statId ?? this.statId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      setPointTotalScore: setPointTotalScore ?? this.setPointTotalScore,
      jumpTotalScore: jumpTotalScore ?? this.jumpTotalScore,
      elbowPositionTotalScore:
          elbowPositionTotalScore ?? this.elbowPositionTotalScore,
      feetDirectionTotalScore:
          feetDirectionTotalScore ?? this.feetDirectionTotalScore,
      shotPathTotalScore: shotPathTotalScore ?? this.shotPathTotalScore,
      followThroughTotalScore:
          followThroughTotalScore ?? this.followThroughTotalScore,
      setPoint: setPoint ?? this.setPoint,
      jump: jump ?? this.jump,
      elbowPosition: elbowPosition ?? this.elbowPosition,
      feetDirection: feetDirection ?? this.feetDirection,
      shotPath: shotPath ?? this.shotPath,
      followThrough: followThrough ?? this.followThrough,
    );
  }

  @override
  String toString() {
    return 'StatisticsRow(statId: $statId, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatisticsRow && other.statId == statId;
  }

  @override
  int get hashCode => statId.hashCode;
}
