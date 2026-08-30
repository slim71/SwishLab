import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/providers/auth_providers.dart';
import 'package:swish_lab/providers/backend_reachability_provider.dart';
import 'package:swish_lab/providers/supabase_provider.dart';
import '../supabase_mock.dart';

void main() {
  late MockSupabaseClient mockSupabase;
  late MockGoTrueClient mockAuth;

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    when(() => mockSupabase.auth).thenReturn(mockAuth);
  });

  group('AppAuthNotifier', () {
    test('initial state is loading', () {
      final notifier = AppAuthNotifier();
      expect(notifier.state, AppAuthStatus.loading);
    });

    test('transitions to authenticated', () {
      final notifier = AppAuthNotifier();
      notifier.setAuthenticated();
      expect(notifier.state, AppAuthStatus.authenticated);
    });

    test('transitions to unauthenticated', () {
      final notifier = AppAuthNotifier();
      notifier.setUnauthenticated();
      expect(notifier.state, AppAuthStatus.unauthenticated);
    });

    test('transitions to offline', () {
      final notifier = AppAuthNotifier();
      notifier.setOffline();
      expect(notifier.state, AppAuthStatus.offline);
    });

    test('transitions back to loading', () {
      final notifier = AppAuthNotifier();
      notifier.setAuthenticated();
      notifier.setLoading();
      expect(notifier.state, AppAuthStatus.loading);
    });
  });

  group('appStatusProvider', () {
    test('returns offline when backendReachabilityProvider is false', () async {
      final container = ProviderContainer(
        overrides: [
          backendReachabilityProvider.overrideWith((ref) => Stream.value(false)),
          appAuthStatusProvider.overrideWith((ref) => AppAuthNotifier()..setAuthenticated()),
        ],
      );
      addTearDown(container.dispose);

      AppAuthStatus status = AppAuthStatus.loading;
      container.listen(appStatusProvider, (prev, next) {
        status = next;
      }, fireImmediately: true);

      // Wait for the stream to emit data
      for (int i = 0; i < 10 && status == AppAuthStatus.loading; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }

      expect(status, AppAuthStatus.offline);
    });

    test('returns authStatus when backendReachabilityProvider is true', () async {
      final container = ProviderContainer(
        overrides: [
          backendReachabilityProvider.overrideWith((ref) => Stream.value(true)),
          appAuthStatusProvider.overrideWith((ref) => AppAuthNotifier()..setAuthenticated()),
        ],
      );
      addTearDown(container.dispose);

      AppAuthStatus status = AppAuthStatus.loading;
      container.listen(appStatusProvider, (prev, next) {
        status = next;
      }, fireImmediately: true);

      for (int i = 0; i < 10 && status == AppAuthStatus.loading; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }

      expect(status, AppAuthStatus.authenticated);
    });

    test('returns loading when backendReachabilityProvider is loading', () {
      final container = ProviderContainer(
        overrides: [
          backendReachabilityProvider.overrideWith((ref) => const Stream.empty()),
          appAuthStatusProvider.overrideWith((ref) => AppAuthNotifier()..setAuthenticated()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(appStatusProvider), AppAuthStatus.loading);
    });

    test('returns offline when backendReachabilityProvider has error', () {
      final container = ProviderContainer(
        overrides: [
          backendReachabilityProvider.overrideWithValue(AsyncValue.error(Exception('error'), StackTrace.current)),
          appAuthStatusProvider.overrideWith((ref) => AppAuthNotifier()..setAuthenticated()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(appStatusProvider), AppAuthStatus.offline);
    });
  });

  group('authUserProvider', () {
    test('refreshes when appAuthStatusProvider changes', () {
      final mockUser = MockUser();
      when(() => mockAuth.currentUser).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          supabaseProvider.overrideWithValue(mockSupabase),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(authUserProvider), null);

      when(() => mockAuth.currentUser).thenReturn(mockUser);
      // Trigger a change in appAuthStatusProvider
      container.read(appAuthStatusProvider.notifier).setAuthenticated();

      expect(container.read(authUserProvider), mockUser);
    });
  });

  group('authServiceProvider', () {
    test('provides an AuthService', () {
      final container = ProviderContainer(
        overrides: [
          supabaseProvider.overrideWithValue(mockSupabase),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(authServiceProvider), isNotNull);
    });
  });
}
