import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/models/statistics_row.dart';
import 'package:swish_lab/models/analysis_data.dart';

void main() {
  group('StatisticsRow', () {
    final now = DateTime.now();
    final stat = StatisticsRow(
      statId: 'stat123',
      userId: 'user456',
      createdAt: now,
      setPointTotalScore: 0.8,
      jump: JumpData(
        phase: 1,
        forwardDistance: 10,
        sideDistance: 2,
        scores: {'total': 0.8},
        totalScore: 0.8,
      ),
    );

    test('fromJson creates a valid object with all sections', () {
      final json = {
        'stat_id': 'stat123',
        'user_id': 'user456',
        'created_at': now.toIso8601String(),
        'set_point_total_score': 0.8,
        'set_point': {
          'ball_eye_distance': 1.0,
          'scores': {'total': 0.8}
        },
        'jump': {
          'phase': 1,
          'forward_distance': 10,
          'scores': {'total': 0.8}
        },
        'elbow_position': {
          'vertical': 10,
          'scores': {'total': 0.8}
        },
        'feet_direction': {
          'left_direction': 1,
          'scores': {'total': 0.8}
        },
        'shot_path': {
          'average_deviation': 1,
          'scores': {'total': 0.8}
        },
        'follow_through': {
          'held': true,
          'scores': {'total': 0.8}
        },
      };
      final result = StatisticsRow.fromJson(json);
      expect(result.statId, 'stat123');
      expect(result.setPoint, isNotNull);
      expect(result.jump, isNotNull);
      expect(result.elbowPosition, isNotNull);
      expect(result.feetDirection, isNotNull);
      expect(result.shotPath, isNotNull);
      expect(result.followThrough, isNotNull);
    });

    test('toJson returns a valid map with all sections', () {
      final s = StatisticsRow(
        statId: '1',
        userId: '1',
        createdAt: now,
        setPoint: SetPointData(
            ballEyeDistance: 1,
            elbowAngle: 1,
            shoulderAngle: 1,
            scores: {},
            totalScore: 0),
        jump: JumpData(
            phase: 1,
            forwardDistance: 1,
            sideDistance: 1,
            scores: {},
            totalScore: 0),
        elbowPosition: ElbowPositionData(
            vertical: 1, horizontal: 1, scores: {}, totalScore: 0),
        feetDirection: FeetDirectionData(
            leftDirection: 1,
            rightDirection: 1,
            leftAngle: 1,
            rightAngle: 1,
            scores: {},
            totalScore: 0),
        shotPath: ShotPathData(
            averageDeviation: 1,
            maxDeviation: 1,
            deviationRatio: 1,
            efficiency: 1,
            angleVariance: 1,
            scores: {},
            totalScore: 0),
        followThrough: FollowThroughData(
            held: true,
            framesHeld: 1,
            finalElbowAngle: 1,
            averageWristAngle: 1,
            averageWristVelocity: 1,
            averageFingerVelocity: 1,
            scores: {},
            totalScore: 0),
      );
      final result = s.toJson();
      expect(result['set_point'], isNotNull);
      expect(result['jump'], isNotNull);
      expect(result['elbow_position'], isNotNull);
      expect(result['feet_direction'], isNotNull);
      expect(result['shot_path'], isNotNull);
      expect(result['follow_through'], isNotNull);
    });

    test('copyWith works correctly with all fields', () {
      final sp = SetPointData(
          ballEyeDistance: 1,
          elbowAngle: 1,
          shoulderAngle: 1,
          scores: {},
          totalScore: 0);
      final updated = stat.copyWith(
        statId: 'new-stat',
        userId: 'new-user',
        createdAt: now,
        setPointTotalScore: 0.9,
        jumpTotalScore: 0.9,
        elbowPositionTotalScore: 0.9,
        feetDirectionTotalScore: 0.9,
        shotPathTotalScore: 0.9,
        followThroughTotalScore: 0.9,
        setPoint: sp,
      );
      expect(updated.statId, 'new-stat');
      expect(updated.userId, 'new-user');
      expect(updated.setPointTotalScore, 0.9);
      expect(updated.jumpTotalScore, 0.9);
      expect(updated.elbowPositionTotalScore, 0.9);
      expect(updated.feetDirectionTotalScore, 0.9);
      expect(updated.shotPathTotalScore, 0.9);
      expect(updated.followThroughTotalScore, 0.9);
      expect(updated.setPoint, sp);
    });

    test('equality and hashCode work correctly', () {
      expect(stat == stat, isTrue);

      final stat2 = StatisticsRow(
        statId: 'stat123',
        userId: 'other',
        createdAt: now,
      );
      expect(stat == stat2, isTrue);
      expect(stat.hashCode, stat2.hashCode);

      final stat3 = stat.copyWith(statId: 'stat456');
      expect(stat == stat3, isFalse);
    });

    test('toString returns expected string', () {
      expect(stat.toString(), contains('stat123'));
      expect(stat.toString(), contains('user456'));
    });
  });
}
