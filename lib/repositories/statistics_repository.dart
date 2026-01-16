import 'package:SwishLab/models/statistics_row.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StatisticsRepository {
  final SupabaseClient _client;

  StatisticsRepository(this._client);

  Future<List<StatisticsRow>> getUserStatistics(String userId) async {
    final response = await _client
        .from('Statistics')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: true);

    return (response as List)
        .map((json) => StatisticsRow.fromJson(json))
        .toList();
  }

  Future<void> insertAnalysisResults({
    required String userId,
    required Map<String, dynamic> analysisData,
  }) async {
    await _client.from('Statistics').insert({
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
  }
}
