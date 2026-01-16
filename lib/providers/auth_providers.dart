import 'package:SwishLab/providers/supabase_provider.dart';
import 'package:SwishLab/services/authentication.dart';
import 'package:SwishLab/state/persisted_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Emits auth state changes (login / logout / token refresh)
final authStateProvider = StreamProvider<AuthState>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return supabase.auth.onAuthStateChange;
});

/// LoggedIn flag tracking Supabase auth state in real-time
final loggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.maybeWhen(
    data: (state) => state.session != null,
    orElse: () => false,
  );
});

/// Provides for the value of the persisted flag, kept in memory at all times
final persistedLoggedInProvider = FutureProvider<bool>((ref) async {
  return AuthStorage.isLoggedIn();
});

/// Current Supabase auth user (null if logged out).
/// Used in Supabase for authentication-related ops.
final authUserProvider = Provider<User?>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return supabase.auth.currentUser;
});

/// Auth service (actions)
final authServiceProvider = Provider<AuthService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return AuthService(supabase);
});
