import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swish_lab/providers/supabase_provider.dart';
import 'package:swish_lab/services/authentication.dart';

import 'backend_reachability_provider.dart';

/// Represents the high-level authentication and connectivity state of the app.
///
/// This enum is used to drive navigation and UI decisions by combining:
/// - authentication status (logged in / logged out)
/// - backend reachability (online / offline)
///
/// States:
/// - [loading]: Initial or transitional state while determining auth status
/// - [authenticated]: User has a valid session
/// - [unauthenticated]: No valid session is present
/// - [offline]: Backend is unreachable (network/DNS/server issue)
enum AppAuthStatus {
  loading,
  authenticated,
  unauthenticated,
  offline,
}

/// Manages the authentication state of the application.
///
/// This [StateNotifier] holds the current [AppAuthStatus] and exposes
/// helper methods to transition between states.
///
/// It is updated by:
/// - Supabase auth listeners (login/logout/session changes)
/// - network/reachability logic (offline detection)
///
/// The state is consumed by higher-level providers (e.g. [appStatusProvider])
/// and used by the router to determine navigation flow.
class AppAuthNotifier extends StateNotifier<AppAuthStatus> {
  AppAuthNotifier() : super(AppAuthStatus.loading);

  void setAuthenticated() => state = AppAuthStatus.authenticated;

  void setUnauthenticated() => state = AppAuthStatus.unauthenticated;

  void setOffline() => state = AppAuthStatus.offline;

  void setLoading() => state = AppAuthStatus.loading;
}

/// Provides the current authenticated [User] from Supabase.
///
/// Returns `null` if no user is logged in.
///
/// This is a direct mapping of `supabase.auth.currentUser` and reflects
/// the locally cached session. It does NOT guarantee that the backend
/// is reachable or that the session is still valid server-side.
///
/// Use this for:
/// - accessing user metadata
/// - passing user info to UI/components
///
/// Do NOT use this for routing decisions — prefer [appStatusProvider].
final authUserProvider = Provider<User?>((ref) {
  final supabase = ref.watch(supabaseProvider);
  // Watch appAuthStatusProvider to ensure this provider refreshes on auth changes
  ref.watch(appAuthStatusProvider);
  return supabase.auth.currentUser;
});

/// Provides an instance of [AuthService] for performing authentication actions.
///
/// This acts as the abstraction layer over Supabase auth operations,
/// such as login, signup, logout, and session management.
///
/// Centralizing auth logic in a service helps:
/// - keep providers lightweight
/// - isolate side effects
/// - improve testability and maintainability
final authServiceProvider = Provider<AuthService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return AuthService(supabase);
});

/// Provides and exposes the current authentication state of the app.
///
/// Backed by [AppAuthNotifier], this is the single source of truth for
/// authentication status within the application.
///
/// This provider reflects ONLY the auth state (session presence),
/// and does not account for backend connectivity.
///
/// For routing and UI decisions, prefer using [appStatusProvider],
/// which combines auth state with network reachability.
final appAuthStatusProvider = StateNotifierProvider<AppAuthNotifier, AppAuthStatus>((ref) {
  return AppAuthNotifier();
});

/// Combines authentication state with backend reachability to produce
/// the effective application state.
///
/// This provider merges:
/// - [appAuthStatusProvider] → authentication state
/// - [backendReachabilityProvider] → network/backend availability
///
/// Behavior:
/// - If the backend is unreachable → returns [AppAuthStatus.offline]
/// - Otherwise → returns the current auth state
/// - While loading → returns [AppAuthStatus.loading]
///
/// This is the preferred provider for:
/// - routing decisions (GoRouter redirects)
/// - top-level UI state handling
///
/// It ensures the app does not treat a user as "authenticated"
/// when the backend is unavailable.
final appStatusProvider = Provider<AppAuthStatus>((ref) {
  final authStatus = ref.watch(appAuthStatusProvider);
  final reachability = ref.watch(backendReachabilityProvider);

  return reachability.when(
    data: (isReachable) {
      if (!isReachable) {
        return AppAuthStatus.offline;
      }
      return authStatus;
    },
    loading: () => AppAuthStatus.loading,
    error: (_, __) => AppAuthStatus.offline,
  );
});
