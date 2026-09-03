import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/models/statistics_row.dart';
import 'package:swish_lab/models/users_row.dart';
import 'package:swish_lab/providers/statistics_provider.dart';
import 'package:swish_lab/providers/users_provider.dart';
import '../test_helper.dart';

void main() {
  late MockStatisticsRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockStatisticsRepository();
  });

  StatisticsRow createStat(String id) {
    return StatisticsRow(statId: id, userId: 'u1', createdAt: DateTime.now());
  }

  group('UserStatisticsState', () {
    test('copyWith updates fields correctly', () {
      const state = UserStatisticsState(
        items: [],
        totalCount: 0,
        hasMore: false,
        isLoadingMore: false,
        overallAvgScore: 0.0,
      );
      final updated = state.copyWith(
        items: [createStat('1')],
        totalCount: 5,
        hasMore: true,
        isLoadingMore: true,
        overallAvgScore: 0.75,
      );

      expect(updated.items.length, 1);
      expect(updated.totalCount, 5);
      expect(updated.hasMore, isTrue);
      expect(updated.isLoadingMore, isTrue);
      expect(updated.overallAvgScore, 0.75);
    });

    test('copyWith keeps existing fields if null provided', () {
      final state = UserStatisticsState(
        items: [createStat('1')],
        totalCount: 1,
        hasMore: true,
        isLoadingMore: true,
        overallAvgScore: 0.8,
      );
      final updated = state.copyWith();

      expect(updated.items, state.items);
      expect(updated.totalCount, state.totalCount);
      expect(updated.hasMore, state.hasMore);
      expect(updated.isLoadingMore, state.isLoadingMore);
      expect(updated.overallAvgScore, state.overallAvgScore);
    });
  });

  group('UserStatisticsNotifier', () {
    test('initialization success flow', () async {
      final user = const UsersRow(id: 'u1', firstName: 'F', lastName: 'L', email: 'e');
      final items = [createStat('1')];

      when(() => mockRepo.getUserStatistics('u1', limit: 20)).thenAnswer((_) async => items);
      when(() => mockRepo.getStatsCount('u1')).thenAnswer((_) async => 1);
      when(() => mockRepo.getOverallAverageScore('u1')).thenAnswer((_) async => 0.85);

      container = createContainer(overrides: [
        statisticsRepositoryProvider.overrideWithValue(mockRepo),
        appUserProvider.overrideWith((ref) => Future.value(user)),
      ]);

      expect(container.read(userStatisticsProvider), const AsyncValue<UserStatisticsState>.loading());

      final state = await container.read(userStatisticsProvider.notifier).stream.first;

      expect(state.value?.items, items);
      expect(state.value?.totalCount, 1);
      expect(state.value?.hasMore, isFalse);
      expect(state.value?.overallAvgScore, 0.85);
    });

    test('initialization handles null user', () async {
      container = createContainer(overrides: [
        statisticsRepositoryProvider.overrideWithValue(mockRepo),
        appUserProvider.overrideWith((ref) => Future.value(null)),
      ]);

      final state = await container.read(userStatisticsProvider.notifier).stream.first;

      expect(state.value?.items, isEmpty);
      expect(state.value?.totalCount, 0);
      expect(state.value?.hasMore, isFalse);
    });

    test('initialization handles errors', () async {
      final user = const UsersRow(id: 'u1', firstName: 'F', lastName: 'L', email: 'e');
      when(() => mockRepo.getUserStatistics('u1', limit: any(named: 'limit'))).thenThrow(Exception('DB Error'));

      container = createContainer(overrides: [
        statisticsRepositoryProvider.overrideWithValue(mockRepo),
        appUserProvider.overrideWith((ref) => Future.value(user)),
      ]);

      final state = await container.read(userStatisticsProvider.notifier).stream.first;

      expect(state.hasError, isTrue);
    });

    test('fetchMore success flow', () async {
      final user = const UsersRow(id: 'u1', firstName: 'F', lastName: 'L', email: 'e');
      final initialItems = List.generate(20, (i) => createStat('$i'));
      final nextItems = [createStat('21')];
      final fetchCompleter = Completer<List<StatisticsRow>>();

      when(() => mockRepo.getUserStatistics('u1', limit: 20)).thenAnswer((_) async => initialItems);
      when(() => mockRepo.getStatsCount('u1')).thenAnswer((_) async => 21);
      when(() => mockRepo.getOverallAverageScore('u1')).thenAnswer((_) async => 0.7);
      when(() => mockRepo.getUserStatistics('u1', limit: 20, offset: 20)).thenAnswer((_) => fetchCompleter.future);

      container = createContainer(overrides: [
        statisticsRepositoryProvider.overrideWithValue(mockRepo),
        appUserProvider.overrideWith((ref) => Future.value(user)),
      ]);

      final notifier = container.read(userStatisticsProvider.notifier);
      await notifier.stream.first;

      final fetchFuture = notifier.fetchMore();

      // Check if isLoadingMore is set to true
      expect(container.read(userStatisticsProvider).value?.isLoadingMore, isTrue);

      fetchCompleter.complete(nextItems);
      await fetchFuture;

      final finalState = container.read(userStatisticsProvider).value!;
      expect(finalState.items.length, 21);
      expect(finalState.isLoadingMore, isFalse);
      expect(finalState.hasMore, isFalse);
      expect(finalState.overallAvgScore, 0.7);
    });

    test('fetchMore skips if already loading or no more data or has error', () async {
      final user = const UsersRow(id: 'u1', firstName: 'F', lastName: 'L', email: 'e');

      when(() => mockRepo.getUserStatistics('u1', limit: 20)).thenAnswer((_) async => []); // hasMore = false
      when(() => mockRepo.getStatsCount('u1')).thenAnswer((_) async => 0);
      when(() => mockRepo.getOverallAverageScore('u1')).thenAnswer((_) async => 0.0);

      container = createContainer(overrides: [
        statisticsRepositoryProvider.overrideWithValue(mockRepo),
        appUserProvider.overrideWith((ref) => Future.value(user)),
      ]);

      final notifier = container.read(userStatisticsProvider.notifier);
      await notifier.stream.first;

      clearInteractions(mockRepo);
      await notifier.fetchMore();
      verifyNever(() => mockRepo.getUserStatistics(any(), limit: any(named: 'limit'), offset: any(named: 'offset')));

      // Test already loading
      // Manually set state to loading more
      notifier.state = const AsyncValue.data(
          UserStatisticsState(items: [], totalCount: 0, hasMore: true, isLoadingMore: true, overallAvgScore: 0.0));
      await notifier.fetchMore();
      verifyNever(() => mockRepo.getUserStatistics(any(), limit: any(named: 'limit'), offset: any(named: 'offset')));

      // Test has error
      notifier.state = AsyncValue.error(Exception('Error'), StackTrace.empty);
      await notifier.fetchMore();
      verifyNever(() => mockRepo.getUserStatistics(any(), limit: any(named: 'limit'), offset: any(named: 'offset')));
    });

    test('fetchMore handles errors by resetting isLoadingMore', () async {
      final user = const UsersRow(id: 'u1', firstName: 'F', lastName: 'L', email: 'e');
      final initialItems = List.generate(20, (i) => createStat('$i'));

      when(() => mockRepo.getUserStatistics('u1', limit: 20)).thenAnswer((_) async => initialItems);
      when(() => mockRepo.getStatsCount('u1')).thenAnswer((_) async => 20);
      when(() => mockRepo.getOverallAverageScore('u1')).thenAnswer((_) async => 0.5);
      when(() => mockRepo.getUserStatistics('u1', limit: 20, offset: 20)).thenThrow(Exception('Network Error'));

      container = createContainer(overrides: [
        statisticsRepositoryProvider.overrideWithValue(mockRepo),
        appUserProvider.overrideWith((ref) => Future.value(user)),
      ]);

      final notifier = container.read(userStatisticsProvider.notifier);
      await notifier.stream.first;

      await notifier.fetchMore();

      final state = container.read(userStatisticsProvider).value!;
      expect(state.isLoadingMore, isFalse);
      expect(state.items.length, 20);
      expect(state.overallAvgScore, 0.5);
    });
  });
}
