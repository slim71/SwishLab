import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swish_lab/models/statistics_row.dart';
import 'package:swish_lab/providers/supabase_provider.dart';
import 'package:swish_lab/repositories/statistics_repository.dart';

import 'users_provider.dart';

/// Repository provider
final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  final client = ref.watch(supabaseProvider);
  return StatisticsRepository(client);
});

/// Statistics for current user
final userStatisticsProvider = FutureProvider<List<StatisticsRow>>((ref) async {
  final user = await ref.watch(appUserProvider.future);

  if (user == null) return [];

  final repo = ref.watch(statisticsRepositoryProvider);
  return repo.getUserStatistics(user.id);
});
