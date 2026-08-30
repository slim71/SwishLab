import '../models/statistics_row.dart';

/// Calculates the average score for a single shooting session.
double calculateSessionAverage(StatisticsRow? row) {
  if (row == null) return 0.0;

  final scores = [
    row.setPointTotalScore,
    row.jumpTotalScore,
    row.elbowPositionTotalScore,
    row.feetDirectionTotalScore,
    row.shotPathTotalScore,
    row.followThroughTotalScore,
  ];

  final validScores = scores.whereType<double>().toList();
  if (validScores.isEmpty) return 0.0;

  return validScores.reduce((a, b) => a + b) / validScores.length;
}
