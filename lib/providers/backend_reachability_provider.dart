import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swish_lab/providers/supabase_provider.dart';

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
  final supabase = ref.watch(supabaseProvider);

  bool? last;

  while (true) {
    bool current;

    try {
      // lightweight ping
      await supabase.from('users').select().limit(1); // TODO: consider adding a 1-row table for this
      current = true;
    } catch (_) {
      current = false;
    }

    if (current != last) {
      yield current;
      last = current;
    }

    await Future.delayed(const Duration(seconds: 5));
  }
});
