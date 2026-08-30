import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../logger.dart';
import 'api_providers.dart';

/// Periodically checks whether the backend (Supabase) is reachable.
final backendReachabilityProvider = StreamProvider<bool>((ref) {
  final logger = AppLogger.scope('BackendReachability');
  final client = ref.watch(httpClientProvider);
  final interval = ref.watch(reachabilityPollingIntervalProvider);

  int consecutiveFailures = 0;
  bool lastReportedStatus = true;

  // Use Stream.periodic for cleaner polling management
  final stream = Stream<void>.periodic(interval).asyncMap<bool>((_) async {
    bool currentReachable;
    try {
      final response = await client.get(Uri.parse('$supabaseDomain/rest/v1/')).timeout(const Duration(seconds: 3));
      currentReachable = response.statusCode < 500;
    } catch (e) {
      currentReachable = false;
    }

    if (currentReachable) {
      consecutiveFailures = 0;
      lastReportedStatus = true;
    } else {
      consecutiveFailures++;
      logger.d('Backend unreachable; consecutive failures: $consecutiveFailures');
      // Only flip to false after 3 consecutive failures
      if (consecutiveFailures >= 3) {
        lastReportedStatus = false;
      }
    }
    return lastReportedStatus;
  });

  // Ensure we emit an initial value immediately and then only on changes
  return stream.distinct();
});
