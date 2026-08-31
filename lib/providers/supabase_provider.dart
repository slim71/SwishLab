import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../state/app_state.dart';
import 'auth_providers.dart';

/// Supabase client: main entry point for interacting with Supabase services
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Sets up a listener for Supabase authentication state changes and
/// keeps the app-level authentication state in sync.
///
/// This provider:
/// - Reads the current session on initialization
/// - Updates [appAuthStatusProvider] accordingly
/// - Subscribes to `onAuthStateChange` for real-time updates
/// - Cleans up the subscription when disposed
final supabaseAuthListenerProvider = Provider<void>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final notifier = ref.read(appAuthStatusProvider.notifier);
  final appStateNotifier = ref.read(appStateProvider.notifier);

  // 1. Synchronously sync initial state to avoid UI flicker
  // Wrap in microtask to avoid "modifying during build" error
  Future.microtask(() {
    try {
      final session = supabase.auth.currentSession;
      if (session?.accessToken == null) {
        notifier.setUnauthenticated();
      } else {
        notifier.setAuthenticated();
      }
    } catch (e) {
      notifier.setOffline();
    }
  });

  // 2. Subscribe to real-time auth changes
  final subscription = supabase.auth.onAuthStateChange.listen((data) {
    final session = data.session;
    // Defer update to avoid "modifying during build" if the stream emits immediately
    Future.microtask(() {
      if (session?.accessToken == null) {
        notifier.setUnauthenticated();
        appStateNotifier.reset();
      } else {
        notifier.setAuthenticated();
      }
    });
  });

  // 3. Guaranteed cleanup when the provider is disposed
  ref.onDispose(() => subscription.cancel());
});
