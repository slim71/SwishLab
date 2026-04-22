import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

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
final backendReachabilityProvider = StreamProvider<bool>((ref) async* {
  bool? last;

  while (true) {
    bool current;

    try {
      final response = await http
          .get(
            Uri.parse('$supabaseDomain/rest/v1/'),
          )
          .timeout(const Duration(seconds: 3));

      // If we get ANY response, backend is reachable
      //debugPrint('Reachability status code: ${response.statusCode}');
      current = response.statusCode < 500;
    } catch (e) {
      current = false;
    }

    if (current != last) {
      yield current;
      last = current;
    }

    await Future<void>.delayed(const Duration(seconds: 5));
  }
});
