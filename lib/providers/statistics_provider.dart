import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/statistics_row.dart';
import '../repositories/statistics_repository.dart';
import 'supabase_provider.dart';
import 'users_provider.dart';
import '../logger.dart';

/// Repository provider
final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  final client = ref.watch(supabaseProvider);
  return StatisticsRepository(client);
});

/// Represents the state of user statistics with pagination metadata.
class UserStatisticsState {
  final List<StatisticsRow> items;
  final int totalCount;
  final bool hasMore;
  final bool isLoadingMore;
  final double overallAvgScore;

  const UserStatisticsState({
    required this.items,
    required this.totalCount,
    required this.hasMore,
    this.isLoadingMore = false,
    this.overallAvgScore = 0.0,
  });

  UserStatisticsState copyWith({
    List<StatisticsRow>? items,
    int? totalCount,
    bool? hasMore,
    bool? isLoadingMore,
    double? overallAvgScore,
  }) {
    return UserStatisticsState(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      overallAvgScore: overallAvgScore ?? this.overallAvgScore,
    );
  }
}

/// Paginated statistics for current user.
class UserStatisticsNotifier extends StateNotifier<AsyncValue<UserStatisticsState>> {
  final Ref ref;
  static const int _pageSize = 20;
  final _logger = AppLogger.scope('UserStatsNotifier');

  UserStatisticsNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> init() async {
    _logger.d('Building UserStatisticsNotifier');
    await _init();
  }

  Future<void> _init() async {
    _logger.i('Initializing statistics...');
    final user = await ref.watch(appUserProvider.future);
    if (user == null) {
      _logger.w('No user found, returning empty state.');
      state = const AsyncValue.data(UserStatisticsState(items: [], totalCount: 0, hasMore: false));
      return;
    }

    try {
      final repo = ref.read(statisticsRepositoryProvider);

      _logger.d('Fetching items, count, and overall average for user: ${user.id}');
      // Fetch items, count, and overall average in parallel
      final results = await Future.wait([
        repo.getUserStatistics(user.id, limit: _pageSize),
        repo.getStatsCount(user.id),
        repo.getOverallAverageScore(user.id),
      ]);
      _logger.d('Fetched: $results');

      final initialItems = results[0] as List<StatisticsRow>;
      final totalCount = results[1] as int;
      final overallAvgScore = results[2] as double;
      _logger.i('Fetched ${initialItems.length} items. Total count: $totalCount. Overall Avg: $overallAvgScore');

      state = AsyncValue.data(UserStatisticsState(
        items: initialItems,
        totalCount: totalCount,
        hasMore: initialItems.length == _pageSize,
        overallAvgScore: overallAvgScore,
      ));
    } catch (e, stack) {
      _logger.e('Error during initialization', error: e, stackTrace: stack);
      state = AsyncValue.error(e, stack);
    }
  }

  /// Fetches the next page of statistics and appends it to the current list.
  Future<void> fetchMore() async {
    final currentState = state.value;
    if (currentState == null || currentState.isLoadingMore || !currentState.hasMore) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    final user = await ref.read(appUserProvider.future);
    if (user == null) return;

    try {
      final repo = ref.read(statisticsRepositoryProvider);
      final nextItems = await repo.getUserStatistics(
        user.id,
        limit: _pageSize,
        offset: currentState.items.length,
      );

      state = AsyncValue.data(UserStatisticsState(
        items: [...currentState.items, ...nextItems],
        totalCount: currentState.totalCount, // Count doesn't change during pagination
        hasMore: nextItems.length == _pageSize,
        isLoadingMore: false,
        overallAvgScore: currentState.overallAvgScore,
      ));
    } catch (e) {
      state = AsyncValue.data(currentState.copyWith(isLoadingMore: false));
    }
  }
}

final userStatisticsProvider =
    StateNotifierProvider.autoDispose<UserStatisticsNotifier, AsyncValue<UserStatisticsState>>(
        (ref) => UserStatisticsNotifier(ref)..init());
