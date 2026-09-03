import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/repositories/statistics_repository.dart';
import '../supabase_mock.dart';

void main() {
  late MockSupabaseClient client;
  late StatisticsRepository repository;

  setUpAll(() {
    setupSupabaseMocks();
  });

  setUp(() {
    client = MockSupabaseClient();
    repository = StatisticsRepository(client);
  });

  test('getUserStatistics smoke test', () async {
    final query = MockSupabaseQueryBuilder();
    final filter = MockPostgrestFilterBuilder<List<Map<String, dynamic>>>();

    when(() => client.from(any())).thenAnswer((_) => query);
    when(() => query.select(any())).thenAnswer((_) => filter);
    when(() => filter.eq(any(), any())).thenAnswer((_) => filter);
    when(() => filter.order(any(), ascending: any(named: 'ascending'))).thenAnswer((_) => filter);

    stubPostgrestAwaitable<List<Map<String, dynamic>>>(filter, <Map<String, dynamic>>[]);

    final result = await repository.getUserStatistics('u1');
    expect(result, isEmpty);
  });

  test('getOverallAverageScore calculates average correctly', () async {
    final query = MockSupabaseQueryBuilder();
    final filter = MockPostgrestFilterBuilder<List<Map<String, dynamic>>>();

    when(() => client.from(any())).thenAnswer((_) => query);
    when(() => query.select(any())).thenAnswer((_) => filter);
    when(() => filter.eq(any(), any())).thenAnswer((_) => filter);

    final mockData = [
      {
        'set_point_total_score': 0.8,
        'jump_total_score': 0.8,
        'elbow_position_total_score': 0.8,
        'feet_direction_total_score': 0.8,
        'shot_path_total_score': 0.8,
        'follow_through_total_score': 0.8,
      },
      {
        'set_point_total_score': 0.6,
        'jump_total_score': 0.6,
        'elbow_position_total_score': 0.6,
        'feet_direction_total_score': 0.6,
        'shot_path_total_score': 0.6,
        'follow_through_total_score': 0.6,
      },
    ];

    stubPostgrestAwaitable<List<Map<String, dynamic>>>(filter, mockData);

    final result = await repository.getOverallAverageScore('u1');
    // (0.8 * 6 / 6 + 0.6 * 6 / 6) / 2 = 0.7
    expect(result, closeTo(0.7, 0.001));
  });

  test('getOverallAverageScore handles empty data', () async {
    final query = MockSupabaseQueryBuilder();
    final filter = MockPostgrestFilterBuilder<List<Map<String, dynamic>>>();

    when(() => client.from(any())).thenAnswer((_) => query);
    when(() => query.select(any())).thenAnswer((_) => filter);
    when(() => filter.eq(any(), any())).thenAnswer((_) => filter);

    stubPostgrestAwaitable<List<Map<String, dynamic>>>(filter, <Map<String, dynamic>>[]);

    final result = await repository.getOverallAverageScore('u1');
    expect(result, 0.0);
  });
}
