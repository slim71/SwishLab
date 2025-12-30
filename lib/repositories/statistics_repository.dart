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
}
