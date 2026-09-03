import 'package:supabase_flutter/supabase_flutter.dart';

import '../logger.dart';
import '../models/statistics_row.dart';

class StatisticsRepository {
  final SupabaseClient _client;
  static const String _tableName = 'statistics';
  final _logger = AppLogger.scope('StatisticsRepo');

  StatisticsRepository(this._client);

  Future<List<StatisticsRow>> getUserStatistics(
    String userId, {
    int? limit,
    int? offset,
  }) async {
    var query = _client.from(_tableName).select().eq('user_id', userId).order('created_at', ascending: false);

    if (limit != null) {
      query = query.limit(limit);
    }

    if (offset != null) {
      // range (start, end) is inclusive
      final start = offset;
      final end = offset + (limit ?? 10) - 1;
      query = query.range(start, end);
    }

    final response = await query;

    return (response as List).map((json) => StatisticsRow.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> insertAnalysisResults({
    required String userId,
    required Map<String, dynamic> analysisData,
  }) async {
    try {
      _logger.i('Inserting analysis results for user: $userId');
      await _client.from(_tableName).insert({
        'user_id': userId,
        'set_point_total_score': analysisData['set_point']?['scores']?['total'],
        'jump_total_score': analysisData['jump']?['scores']?['total'],
        'elbow_position_total_score': analysisData['elbow_position']?['scores']?['total'],
        'feet_direction_total_score': analysisData['feet_direction']?['scores']?['total'],
        'shot_path_total_score': analysisData['shot_path']?['scores']?['total'],
        'follow_through_total_score': analysisData['follow_through']?['scores']?['total'],
        'set_point': analysisData['set_point'],
        'jump': analysisData['jump'],
        'elbow_position': analysisData['elbow_position'],
        'feet_direction': analysisData['feet_direction'],
        'shot_path': analysisData['shot_path'],
        'follow_through': analysisData['follow_through'],
      });
      _logger.i('Analysis results inserted successfully.');
    } catch (e, stack) {
      _logger.e('FAILED to insert analysis results into Supabase', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> clearStatistics(String userId) async {
    await _client.from(_tableName).delete().eq('user_id', userId);
  }

  /// Returns the total number of shooting sessions for a user.
  Future<int> getStatsCount(String userId) async {
    try {
      final response = await _client.from(_tableName).select('stat_id').eq('user_id', userId).count(CountOption.exact);
      return response.count;
    } catch (e) {
      _logger.e('Error fetching stats count', error: e);
      return 0;
    }
  }

  /// Returns the overall average score for a user across all sessions.
  Future<double> getOverallAverageScore(String userId) async {
    try {
      final response = await _client
          .from(_tableName)
          .select(
            'set_point_total_score, '
            'jump_total_score, '
            'elbow_position_total_score, '
            'feet_direction_total_score, '
            'shot_path_total_score, '
            'follow_through_total_score',
          )
          .eq('user_id', userId);

      final List<dynamic> rows = response as List<dynamic>;
      if (rows.isEmpty) return 0.0;

      double totalSumOfAverages = 0;
      for (var row in rows) {
        double rowSum = 0;
        rowSum += (row['set_point_total_score'] ?? 0.0) as num;
        rowSum += (row['jump_total_score'] ?? 0.0) as num;
        rowSum += (row['elbow_position_total_score'] ?? 0.0) as num;
        rowSum += (row['feet_direction_total_score'] ?? 0.0) as num;
        rowSum += (row['shot_path_total_score'] ?? 0.0) as num;
        rowSum += (row['follow_through_total_score'] ?? 0.0) as num;
        totalSumOfAverages += (rowSum / 6.0);
      }

      return totalSumOfAverages / rows.length;
    } catch (e) {
      _logger.e('Error fetching overall average score', error: e);
      return 0.0;
    }
  }
}
