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
}
