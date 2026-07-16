import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../logger.dart';

/// Periodically checks whether the backend (Supabase) is reachable.
///
/// This provider emits a boolean stream indicating connectivity:
/// - `true`  → backend is reachable
/// - `false` → backend is unreachable (e.g. network issues, DNS failure,
///             paused Supabase project)
///
/// It performs a lightweight query against the database to force a real
/// network request. This ensures detection of issues that are not visible
/// through cached auth state (e.g. `currentSession`).
///
/// To avoid unnecessary rebuilds, values are only emitted when the
/// reachability status changes.
///
/// Polling interval: 5 seconds.
///
/// Notes:
/// - The queried table should be small and always available.
///   Consider using a dedicated 1-row "health_check" table.
/// - This is a polling-based approach; for more advanced use cases,
///   it can be replaced with event-driven connectivity detection.
///
/// Used by [appStatusProvider] to determine whether the app should
/// enter the [AppAuthStatus.offline] state.
/// Requires 3 consecutive failures to report as unreachable to avoid
/// blips triggering logouts.
final backendReachabilityProvider = StreamProvider<bool>((ref) async* {
  bool? last;
  int consecutiveFailures = 0;
  final logger = AppLogger.scope('BackendReachability');

  while (true) {
    bool currentReachable;

    try {
      final response = await http.get(Uri.parse('$supabaseDomain/rest/v1/')).timeout(const Duration(seconds: 3));

      // If we get ANY response, backend is reachable
      currentReachable = response.statusCode < 500;
    } catch (e) {
      currentReachable = false;
    }

    bool reportedStatus;
    if (currentReachable) {
      consecutiveFailures = 0;
      reportedStatus = true;
    } else {
      logger.d('Backend unreachable; consecutive failures: $consecutiveFailures');
      consecutiveFailures++;
      // Only report as unreachable if it failed 3 times in a row
      if (consecutiveFailures >= 3) {
        reportedStatus = false;
      } else {
        // Keep the previous status (likely true) until 3 failures reached
        reportedStatus = last ?? true;
      }
    }

    if (reportedStatus != last) {
      yield reportedStatus;
      last = reportedStatus;
    }

    await Future<void>.delayed(const Duration(seconds: 5));
  }
});
