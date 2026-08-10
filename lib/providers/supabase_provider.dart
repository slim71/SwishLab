import 'dart:async';

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

  StreamSubscription<AuthState>? sub;

  Future.microtask(() async {
    final notifier = ref.read(appAuthStatusProvider.notifier);

    try {
      // Initial session
      final session = supabase.auth.currentSession;

      if (session?.accessToken == null) {
        notifier.setUnauthenticated();
      } else {
        notifier.setAuthenticated();
      }
    } catch (e) {
      // If offline, we might get a SocketException or AuthRetryableFetchException
      // We set unauthenticated or offline based on intent,
      // but here we just want to avoid crashing.
      notifier.setOffline();
    }

    // Listen to changes
    sub = supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;

      if (session?.accessToken == null) {
        notifier.setUnauthenticated();
        // Reset app state on logout
        ref.read(appStateProvider.notifier).reset();
      } else {
        notifier.setAuthenticated();
      }
    });
  });

  // Proper cleanup
  ref.onDispose(() {
    sub?.cancel();
  });
});
