import 'package:SwishLab/models/statistics_row.dart';
import 'package:SwishLab/repositories/statistics_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'users_provider.dart';

/// Repository provider
final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  return StatisticsRepository(Supabase.instance.client);
});

/// Statistics for current user
final userStatisticsProvider = FutureProvider<List<StatisticsRow>>((ref) async {
  final userAsync = ref.watch(currentUserProvider);

  final user = userAsync.value;
  if (user == null) {
    return [];
  }

  final repo = ref.watch(statisticsRepositoryProvider);
  return repo.getUserStatistics(user.id);
});
