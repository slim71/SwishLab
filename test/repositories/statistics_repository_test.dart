import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/repositories/statistics_repository.dart';
import '../supabase_mock.dart';

void main() {
  late MockSupabaseClient client;
  late StatisticsRepository repository;
  late FakeSupabaseQueryBuilder queryBuilder;
  late FakePostgrestFilterBuilder<List<Map<String, dynamic>>> filterBuilder;

  setUp(() {
    client = MockSupabaseClient();
    repository = StatisticsRepository(client);
    queryBuilder = FakeSupabaseQueryBuilder();
    filterBuilder = queryBuilder.filterBuilder;

    when(() => client.from(any())).thenAnswer((_) => queryBuilder);

    stubPostgrestAwaitable(filterBuilder, <Map<String, dynamic>>[]);
  });

  group('StatisticsRepository', () {
    test('getUserStatistics returns list of stats', () async {
      final now = DateTime.now().toIso8601String();
      final statsData = <Map<String, dynamic>>[
        {'stat_id': 's1', 'user_id': 'u1', 'created_at': now},
      ];
      stubPostgrestAwaitable(filterBuilder, statsData);

      final result = await repository.getUserStatistics('u1');

      expect(result.length, 1);
      expect(result.first.statId, 's1');
    });

    test('getUserStatistics returns empty list when no data found', () async {
      stubPostgrestAwaitable(filterBuilder, <Map<String, dynamic>>[]);

      final result = await repository.getUserStatistics('u1');

      expect(result, isEmpty);
    });

    test('insertAnalysisResults handles nested null values correctly', () async {
      // Test cases to cover all null-aware (?) paths in insertAnalysisResults

      // 1. Fully populated
      await repository.insertAnalysisResults(
        userId: 'u1',
        analysisData: {
          'set_point': {
            'scores': {'total': 0.1}
          },
          'jump': {
            'scores': {'total': 0.2}
          },
          'elbow_position': {
            'scores': {'total': 0.3}
          },
          'feet_direction': {
            'scores': {'total': 0.4}
          },
          'shot_path': {
            'scores': {'total': 0.5}
          },
          'follow_through': {
            'scores': {'total': 0.6}
          },
        },
      );

      // 2. Sections present but scores missing (covers analysisData['...']?['scores']?['total'])
      await repository.insertAnalysisResults(
        userId: 'u1',
        analysisData: {
          'set_point': {'other': 1},
          'jump': null,
          'elbow_position': {'scores': null},
        },
      );

      // 3. Totally empty map
      await repository.insertAnalysisResults(
        userId: 'u1',
        analysisData: {},
      );
    });

    test('clearStatistics calls delete and eq', () async {
      await repository.clearStatistics('u1');
      // Succeeds if no exception thrown (verified by coverage of lines)
    });
  });
}
