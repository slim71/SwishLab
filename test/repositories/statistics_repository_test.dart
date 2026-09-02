import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/repositories/statistics_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_mock.dart';

// ignore: avoid_implementing_value_types
class _MockFilter extends Mock implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}

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
    final filter = _MockFilter();

    when(() => client.from(any())).thenAnswer((_) => query);
    when(() => query.select(any())).thenAnswer((_) => filter);
    when(() => filter.eq(any(), any())).thenAnswer((_) => filter);
    when(() => filter.order(any(), ascending: any(named: 'ascending'))).thenAnswer((_) => filter);

    when(() => filter.then(any())).thenAnswer((inv) {
      final cb = inv.positionalArguments[0] as Function;
      return Future.value(cb([]));
    });

    final result = await repository.getUserStatistics('u1');
    expect(result, isEmpty);
  });
}
