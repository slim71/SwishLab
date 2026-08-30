import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/models/analysis_data.dart';

void main() {
  group('AnalysisSection', () {
    test('parseScores handles null', () {
      expect(AnalysisSection.parseScores(null), <String, double>{});
    });

    test('parseScores handles valid map', () {
      final json = {'a': 1, 'b': 2.5};
      final result = AnalysisSection.parseScores(json);
      expect(result, {'a': 1.0, 'b': 2.5});
    });

    test('equality and hashCode', () {
      const scores = {'total': 80.0};
      final s1 = SetPointData(
        ballEyeDistance: 1.0,
        elbowAngle: 2.0,
        shoulderAngle: 3.0,
        scores: scores,
        totalScore: 80.0,
      );
      final s2 = SetPointData(
        ballEyeDistance: 1.0,
        elbowAngle: 2.0,
        shoulderAngle: 3.0,
        scores: scores,
        totalScore: 80.0,
      );
      final s3 = SetPointData(
        ballEyeDistance: 2.0,
        elbowAngle: 2.0,
        shoulderAngle: 3.0,
        scores: scores,
        totalScore: 80.0,
      );

      expect(s1, s2);
      expect(s1.hashCode, s2.hashCode);
      expect(s1 == s3, isFalse);
      expect(s1 == Object(), isFalse);
    });
  });

  group('SetPointData', () {
    test('fromJson and toJson', () {
      final json = {
        'ball_eye_distance': 1.0,
        'elbow_angle': 90.0,
        'shoulder_angle': 45.0,
        'scores': {'total': 85.0}
      };
      final data = SetPointData.fromJson(json);
      expect(data.ballEyeDistance, 1.0);
      expect(data.totalScore, 85.0);
      expect(data.toJson(), containsPair('ball_eye_distance', 1.0));
    });

    test('equality branches', () {
      final d = SetPointData(ballEyeDistance: 1, elbowAngle: 1, shoulderAngle: 1, scores: {}, totalScore: 0);
      expect(
          d == SetPointData(ballEyeDistance: 2, elbowAngle: 1, shoulderAngle: 1, scores: {}, totalScore: 0), isFalse);
      expect(
          d == SetPointData(ballEyeDistance: 1, elbowAngle: 2, shoulderAngle: 1, scores: {}, totalScore: 0), isFalse);
      expect(
          d == SetPointData(ballEyeDistance: 1, elbowAngle: 1, shoulderAngle: 2, scores: {}, totalScore: 0), isFalse);
    });
  });

  group('JumpData', () {
    test('fromJson and toJson', () {
      final json = {
        'phase': 0.5,
        'forward_distance': 10.0,
        'side_distance': 2.0,
        'scores': {'total': 70.0}
      };
      final data = JumpData.fromJson(json);
      expect(data.phase, 0.5);
      expect(data.totalScore, 70.0);
      expect(data.toJson(), containsPair('phase', 0.5));
    });

    test('equality and hashCode', () {
      final j1 = JumpData(phase: 1, forwardDistance: 2, sideDistance: 3, scores: const {}, totalScore: 0);
      final j2 = JumpData(phase: 1, forwardDistance: 2, sideDistance: 3, scores: const {}, totalScore: 0);
      expect(j1, j2);
      expect(j1.hashCode, j2.hashCode);
      expect(j1 == JumpData(phase: 2, forwardDistance: 2, sideDistance: 3, scores: {}, totalScore: 0), isFalse);
      expect(j1 == JumpData(phase: 1, forwardDistance: 3, sideDistance: 3, scores: {}, totalScore: 0), isFalse);
      expect(j1 == JumpData(phase: 1, forwardDistance: 2, sideDistance: 4, scores: {}, totalScore: 0), isFalse);
    });
  });

  group('ElbowPositionData', () {
    test('fromJson and toJson', () {
      final json = {
        'vertical': 10.0,
        'horizontal': 5.0,
        'scores': {'total': 90.0}
      };
      final data = ElbowPositionData.fromJson(json);
      expect(data.vertical, 10.0);
      expect(data.toJson(), containsPair('vertical', 10.0));
    });

    test('equality and hashCode', () {
      final e1 = ElbowPositionData(vertical: 1, horizontal: 2, scores: const {}, totalScore: 0);
      final e2 = ElbowPositionData(vertical: 1, horizontal: 2, scores: const {}, totalScore: 0);
      expect(e1, e2);
      expect(e1.hashCode, e2.hashCode);
      expect(e1 == ElbowPositionData(vertical: 2, horizontal: 2, scores: {}, totalScore: 0), isFalse);
      expect(e1 == ElbowPositionData(vertical: 1, horizontal: 3, scores: {}, totalScore: 0), isFalse);
    });
  });

  group('FeetDirectionData', () {
    test('fromJson and toJson', () {
      final json = {
        'left_direction': 1.0,
        'right_direction': 1.0,
        'left_angle': 45.0,
        'right_angle': 45.0,
        'scores': {'total': 80.0}
      };
      final data = FeetDirectionData.fromJson(json);
      expect(data.leftDirection, 1.0);
      expect(data.toJson(), containsPair('left_direction', 1.0));
    });

    test('equality and hashCode', () {
      final f1 = FeetDirectionData(
          leftDirection: 1, rightDirection: 2, leftAngle: 3, rightAngle: 4, scores: const {}, totalScore: 0);
      final f2 = FeetDirectionData(
          leftDirection: 1, rightDirection: 2, leftAngle: 3, rightAngle: 4, scores: const {}, totalScore: 0);
      expect(f1, f2);
      expect(f1.hashCode, f2.hashCode);
      expect(
          f1 ==
              FeetDirectionData(
                  leftDirection: 2, rightDirection: 2, leftAngle: 3, rightAngle: 4, scores: {}, totalScore: 0),
          isFalse);
      expect(
          f1 ==
              FeetDirectionData(
                  leftDirection: 1, rightDirection: 3, leftAngle: 3, rightAngle: 4, scores: {}, totalScore: 0),
          isFalse);
      expect(
          f1 ==
              FeetDirectionData(
                  leftDirection: 1, rightDirection: 2, leftAngle: 4, rightAngle: 4, scores: {}, totalScore: 0),
          isFalse);
      expect(
          f1 ==
              FeetDirectionData(
                  leftDirection: 1, rightDirection: 2, leftAngle: 3, rightAngle: 5, scores: {}, totalScore: 0),
          isFalse);
    });
  });

  group('ShotPathData', () {
    test('fromJson and toJson', () {
      final json = {
        'average_deviation': 1.0,
        'max_deviation': 2.0,
        'deviation_ratio': 0.5,
        'efficiency': 0.9,
        'angle_variance': 0.1,
        'scores': {'total': 95.0}
      };
      final data = ShotPathData.fromJson(json);
      expect(data.averageDeviation, 1.0);
      expect(data.toJson(), containsPair('average_deviation', 1.0));
    });

    test('equality and hashCode', () {
      final s1 = ShotPathData(
          averageDeviation: 1,
          maxDeviation: 2,
          deviationRatio: 3,
          efficiency: 4,
          angleVariance: 5,
          scores: const {},
          totalScore: 0);
      final s2 = ShotPathData(
          averageDeviation: 1,
          maxDeviation: 2,
          deviationRatio: 3,
          efficiency: 4,
          angleVariance: 5,
          scores: const {},
          totalScore: 0);
      expect(s1, s2);
      expect(s1.hashCode, s2.hashCode);
      expect(
          s1 ==
              ShotPathData(
                  averageDeviation: 2,
                  maxDeviation: 2,
                  deviationRatio: 3,
                  efficiency: 4,
                  angleVariance: 5,
                  scores: {},
                  totalScore: 0),
          isFalse);
      expect(
          s1 ==
              ShotPathData(
                  averageDeviation: 1,
                  maxDeviation: 3,
                  deviationRatio: 3,
                  efficiency: 4,
                  angleVariance: 5,
                  scores: {},
                  totalScore: 0),
          isFalse);
      expect(
          s1 ==
              ShotPathData(
                  averageDeviation: 1,
                  maxDeviation: 2,
                  deviationRatio: 4,
                  efficiency: 4,
                  angleVariance: 5,
                  scores: {},
                  totalScore: 0),
          isFalse);
      expect(
          s1 ==
              ShotPathData(
                  averageDeviation: 1,
                  maxDeviation: 2,
                  deviationRatio: 3,
                  efficiency: 5,
                  angleVariance: 5,
                  scores: {},
                  totalScore: 0),
          isFalse);
      expect(
          s1 ==
              ShotPathData(
                  averageDeviation: 1,
                  maxDeviation: 2,
                  deviationRatio: 3,
                  efficiency: 4,
                  angleVariance: 6,
                  scores: {},
                  totalScore: 0),
          isFalse);
    });
  });

  group('FollowThroughData', () {
    test('fromJson and toJson', () {
      final json = {
        'held': true,
        'frames_held': 30,
        'final_elbow_angle': 170.0,
        'average_wrist_angle': 160.0,
        'average_wrist_velocity': 5.0,
        'average_finger_velocity': 10.0,
        'scores': {'total': 88.0}
      };
      final data = FollowThroughData.fromJson(json);
      expect(data.held, true);
      expect(data.framesHeld, 30);
      expect(data.toJson(), containsPair('held', true));
    });

    test('equality and hashCode', () {
      final f1 = FollowThroughData(
          held: true,
          framesHeld: 1,
          finalElbowAngle: 2,
          averageWristAngle: 3,
          averageWristVelocity: 4,
          averageFingerVelocity: 5,
          scores: const {},
          totalScore: 0);
      final f2 = FollowThroughData(
          held: true,
          framesHeld: 1,
          finalElbowAngle: 2,
          averageWristAngle: 3,
          averageWristVelocity: 4,
          averageFingerVelocity: 5,
          scores: const {},
          totalScore: 0);
      expect(f1, f2);
      expect(f1.hashCode, f2.hashCode);
      expect(
          f1 ==
              FollowThroughData(
                  held: false,
                  framesHeld: 1,
                  finalElbowAngle: 2,
                  averageWristAngle: 3,
                  averageWristVelocity: 4,
                  averageFingerVelocity: 5,
                  scores: {},
                  totalScore: 0),
          isFalse);
      expect(
          f1 ==
              FollowThroughData(
                  held: true,
                  framesHeld: 2,
                  finalElbowAngle: 2,
                  averageWristAngle: 3,
                  averageWristVelocity: 4,
                  averageFingerVelocity: 5,
                  scores: {},
                  totalScore: 0),
          isFalse);
      expect(
          f1 ==
              FollowThroughData(
                  held: true,
                  framesHeld: 1,
                  finalElbowAngle: 3,
                  averageWristAngle: 3,
                  averageWristVelocity: 4,
                  averageFingerVelocity: 5,
                  scores: {},
                  totalScore: 0),
          isFalse);
      expect(
          f1 ==
              FollowThroughData(
                  held: true,
                  framesHeld: 1,
                  finalElbowAngle: 2,
                  averageWristAngle: 4,
                  averageWristVelocity: 4,
                  averageFingerVelocity: 5,
                  scores: {},
                  totalScore: 0),
          isFalse);
      expect(
          f1 ==
              FollowThroughData(
                  held: true,
                  framesHeld: 1,
                  finalElbowAngle: 2,
                  averageWristAngle: 3,
                  averageWristVelocity: 5,
                  averageFingerVelocity: 5,
                  scores: {},
                  totalScore: 0),
          isFalse);
      expect(
          f1 ==
              FollowThroughData(
                  held: true,
                  framesHeld: 1,
                  finalElbowAngle: 2,
                  averageWristAngle: 3,
                  averageWristVelocity: 4,
                  averageFingerVelocity: 6,
                  scores: {},
                  totalScore: 0),
          isFalse);
    });
  });
}
