import 'package:flutter/foundation.dart';

abstract class AnalysisSection {
  final Map<String, double> scores;
  final double totalScore;

  AnalysisSection({
    required this.scores,
    required this.totalScore,
  });

  Map<String, dynamic> toJson();

  static Map<String, double> parseScores(Map<String, dynamic>? json) {
    if (json == null) return {};
    return json.map((k, v) {
      return MapEntry(k, toDouble(v) ?? 0.0);
    });
  }

  static double? toDouble(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val);
    return null;
  }

  static int? toInt(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val);
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnalysisSection && mapEquals(other.scores, scores) && other.totalScore == totalScore;
  }

  @override
  int get hashCode => scores.hashCode ^ totalScore.hashCode;
}

class SetPointData extends AnalysisSection {
  final double ballEyeDistance;
  final double elbowAngle;
  final double shoulderAngle;

  SetPointData({
    required this.ballEyeDistance,
    required this.elbowAngle,
    required this.shoulderAngle,
    required super.scores,
    required super.totalScore,
  });

  factory SetPointData.fromJson(Map<String, dynamic> json) {
    final scoresMap = AnalysisSection.parseScores(json['scores'] as Map<String, dynamic>?);
    return SetPointData(
      ballEyeDistance: AnalysisSection.toDouble(json['ball_eye_distance']) ?? 0.0,
      elbowAngle: AnalysisSection.toDouble(json['elbow_angle']) ?? 0.0,
      shoulderAngle: AnalysisSection.toDouble(json['shoulder_angle']) ?? 0.0,
      scores: scoresMap,
      totalScore: scoresMap['total'] ?? 0.0,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'ball_eye_distance': ballEyeDistance,
        'elbow_angle': elbowAngle,
        'shoulder_angle': shoulderAngle,
        'scores': scores,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SetPointData &&
        super == other &&
        other.ballEyeDistance == ballEyeDistance &&
        other.elbowAngle == elbowAngle &&
        other.shoulderAngle == shoulderAngle;
  }

  @override
  int get hashCode => super.hashCode ^ ballEyeDistance.hashCode ^ elbowAngle.hashCode ^ shoulderAngle.hashCode;
}

class JumpData extends AnalysisSection {
  final double phase;
  final double forwardDistance;
  final double sideDistance;

  JumpData({
    required this.phase,
    required this.forwardDistance,
    required this.sideDistance,
    required super.scores,
    required super.totalScore,
  });

  factory JumpData.fromJson(Map<String, dynamic> json) {
    final scoresMap = AnalysisSection.parseScores(json['scores'] as Map<String, dynamic>?);
    return JumpData(
      phase: AnalysisSection.toDouble(json['phase']) ?? 0.0,
      forwardDistance: AnalysisSection.toDouble(json['forward_distance']) ?? 0.0,
      sideDistance: AnalysisSection.toDouble(json['side_distance']) ?? 0.0,
      scores: scoresMap,
      totalScore: scoresMap['total'] ?? 0.0,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'phase': phase,
        'forward_distance': forwardDistance,
        'side_distance': sideDistance,
        'scores': scores,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JumpData &&
        super == other &&
        other.phase == phase &&
        other.forwardDistance == forwardDistance &&
        other.sideDistance == sideDistance;
  }

  @override
  int get hashCode => super.hashCode ^ phase.hashCode ^ forwardDistance.hashCode ^ sideDistance.hashCode;
}

class ElbowPositionData extends AnalysisSection {
  final double vertical;
  final double horizontal;

  ElbowPositionData({
    required this.vertical,
    required this.horizontal,
    required super.scores,
    required super.totalScore,
  });

  factory ElbowPositionData.fromJson(Map<String, dynamic> json) {
    final scoresMap = AnalysisSection.parseScores(json['scores'] as Map<String, dynamic>?);
    return ElbowPositionData(
      vertical: AnalysisSection.toDouble(json['vertical']) ?? 0.0,
      horizontal: AnalysisSection.toDouble(json['horizontal']) ?? 0.0,
      scores: scoresMap,
      totalScore: scoresMap['total'] ?? 0.0,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'vertical': vertical,
        'horizontal': horizontal,
        'scores': scores,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ElbowPositionData && super == other && other.vertical == vertical && other.horizontal == horizontal;
  }

  @override
  int get hashCode => super.hashCode ^ vertical.hashCode ^ horizontal.hashCode;
}

class FeetDirectionData extends AnalysisSection {
  final double leftDirection;
  final double rightDirection;
  final double leftAngle;
  final double rightAngle;

  FeetDirectionData({
    required this.leftDirection,
    required this.rightDirection,
    required this.leftAngle,
    required this.rightAngle,
    required super.scores,
    required super.totalScore,
  });

  factory FeetDirectionData.fromJson(Map<String, dynamic> json) {
    final scoresMap = AnalysisSection.parseScores(json['scores'] as Map<String, dynamic>?);
    return FeetDirectionData(
      leftDirection: AnalysisSection.toDouble(json['left_direction']) ?? 0.0,
      rightDirection: AnalysisSection.toDouble(json['right_direction']) ?? 0.0,
      leftAngle: AnalysisSection.toDouble(json['left_angle']) ?? 0.0,
      rightAngle: AnalysisSection.toDouble(json['right_angle']) ?? 0.0,
      scores: scoresMap,
      totalScore: scoresMap['total'] ?? 0.0,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'left_direction': leftDirection,
        'right_direction': rightDirection,
        'left_angle': leftAngle,
        'right_angle': rightAngle,
        'scores': scores,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeetDirectionData &&
        super == other &&
        other.leftDirection == leftDirection &&
        other.rightDirection == rightDirection &&
        other.leftAngle == leftAngle &&
        other.rightAngle == rightAngle;
  }

  @override
  int get hashCode =>
      super.hashCode ^ leftDirection.hashCode ^ rightDirection.hashCode ^ leftAngle.hashCode ^ rightAngle.hashCode;
}

class ShotPathData extends AnalysisSection {
  final double averageDeviation;
  final double maxDeviation;
  final double deviationRatio;
  final double efficiency;
  final double angleVariance;

  ShotPathData({
    required this.averageDeviation,
    required this.maxDeviation,
    required this.deviationRatio,
    required this.efficiency,
    required this.angleVariance,
    required super.scores,
    required super.totalScore,
  });

  factory ShotPathData.fromJson(Map<String, dynamic> json) {
    final scoresMap = AnalysisSection.parseScores(json['scores'] as Map<String, dynamic>?);
    return ShotPathData(
      averageDeviation: AnalysisSection.toDouble(json['average_deviation']) ?? 0.0,
      maxDeviation: AnalysisSection.toDouble(json['max_deviation']) ?? 0.0,
      deviationRatio: AnalysisSection.toDouble(json['deviation_ratio']) ?? 0.0,
      efficiency: AnalysisSection.toDouble(json['efficiency']) ?? 0.0,
      angleVariance: AnalysisSection.toDouble(json['angle_variance']) ?? 0.0,
      scores: scoresMap,
      totalScore: scoresMap['total'] ?? 0.0,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'average_deviation': averageDeviation,
        'max_deviation': maxDeviation,
        'deviation_ratio': deviationRatio,
        'efficiency': efficiency,
        'angle_variance': angleVariance,
        'scores': scores,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShotPathData &&
        super == other &&
        other.averageDeviation == averageDeviation &&
        other.maxDeviation == maxDeviation &&
        other.deviationRatio == deviationRatio &&
        other.efficiency == efficiency &&
        other.angleVariance == angleVariance;
  }

  @override
  int get hashCode =>
      super.hashCode ^
      averageDeviation.hashCode ^
      maxDeviation.hashCode ^
      deviationRatio.hashCode ^
      efficiency.hashCode ^
      angleVariance.hashCode;
}

class FollowThroughData extends AnalysisSection {
  final bool held;
  final int framesHeld;
  final double finalElbowAngle;
  final double averageWristAngle;
  final double averageWristVelocity;
  final double averageFingerVelocity;

  FollowThroughData({
    required this.held,
    required this.framesHeld,
    required this.finalElbowAngle,
    required this.averageWristAngle,
    required this.averageWristVelocity,
    required this.averageFingerVelocity,
    required super.scores,
    required super.totalScore,
  });

  factory FollowThroughData.fromJson(Map<String, dynamic> json) {
    final scoresMap = AnalysisSection.parseScores(json['scores'] as Map<String, dynamic>?);
    return FollowThroughData(
      held: json['held'] as bool? ?? false,
      framesHeld: AnalysisSection.toInt(json['frames_held']) ?? 0,
      finalElbowAngle: AnalysisSection.toDouble(json['final_elbow_angle']) ?? 0.0,
      averageWristAngle: AnalysisSection.toDouble(json['average_wrist_angle']) ?? 0.0,
      averageWristVelocity: AnalysisSection.toDouble(json['average_wrist_velocity']) ?? 0.0,
      averageFingerVelocity: AnalysisSection.toDouble(json['average_finger_velocity']) ?? 0.0,
      scores: scoresMap,
      totalScore: scoresMap['total'] ?? 0.0,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'held': held,
        'frames_held': framesHeld,
        'final_elbow_angle': finalElbowAngle,
        'average_wrist_angle': averageWristAngle,
        'average_wrist_velocity': averageWristVelocity,
        'average_finger_velocity': averageFingerVelocity,
        'scores': scores,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FollowThroughData &&
        super == other &&
        other.held == held &&
        other.framesHeld == framesHeld &&
        other.finalElbowAngle == finalElbowAngle &&
        other.averageWristAngle == averageWristAngle &&
        other.averageWristVelocity == averageWristVelocity &&
        other.averageFingerVelocity == averageFingerVelocity;
  }

  @override
  int get hashCode =>
      super.hashCode ^
      held.hashCode ^
      framesHeld.hashCode ^
      finalElbowAngle.hashCode ^
      averageWristAngle.hashCode ^
      averageWristVelocity.hashCode ^
      averageFingerVelocity.hashCode;
}
