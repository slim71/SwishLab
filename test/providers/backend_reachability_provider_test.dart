import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:swish_lab/providers/api_providers.dart';
import 'package:swish_lab/providers/backend_reachability_provider.dart';

void main() {
  group('backendReachabilityProvider', () {
    test('emits true on successful reachability', () async {
      final mockClient = MockClient((request) async {
        return http.Response('ok', 200);
      });

      final container = ProviderContainer(
        overrides: [
          httpClientProvider.overrideWithValue(mockClient),
          reachabilityPollingIntervalProvider.overrideWithValue(Duration.zero),
        ],
      );
      addTearDown(container.dispose);

      final values = <bool>[];
      container.listen<AsyncValue<bool>>(
        backendReachabilityProvider,
        (prev, next) {
          next.whenData((v) => values.add(v));
        },
        fireImmediately: true,
      );

      // Allow some time for the stream to emit
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(values, contains(true));
    });

    test('emits false after 3 consecutive failures (status >= 500)', () async {
      int callCount = 0;
      final mockClient = MockClient((request) async {
        callCount++;
        return http.Response('error', 500);
      });

      final container = ProviderContainer(
        overrides: [
          httpClientProvider.overrideWithValue(mockClient),
          reachabilityPollingIntervalProvider.overrideWithValue(Duration.zero),
        ],
      );
      addTearDown(container.dispose);

      final values = <bool>[];
      container.listen<AsyncValue<bool>>(
        backendReachabilityProvider,
        (prev, next) {
          next.whenData((v) => values.add(v));
        },
        fireImmediately: true,
      );

      // Wait for multiple polls
      await Future<void>.delayed(const Duration(milliseconds: 500));

      expect(values, contains(true)); // Initially true (last ?? true logic)
      expect(values, contains(false)); // Eventually false after 3 failures
      expect(callCount, greaterThanOrEqualTo(3));
    });

    test('emits false after 3 consecutive failures (exception)', () async {
      final mockClient = MockClient((request) async {
        throw Exception('Network error');
      });

      final container = ProviderContainer(
        overrides: [
          httpClientProvider.overrideWithValue(mockClient),
          reachabilityPollingIntervalProvider.overrideWithValue(Duration.zero),
        ],
      );
      addTearDown(container.dispose);

      final values = <bool>[];
      container.listen<AsyncValue<bool>>(
        backendReachabilityProvider,
        (prev, next) {
          next.whenData((v) => values.add(v));
        },
        fireImmediately: true,
      );

      await Future<void>.delayed(const Duration(milliseconds: 500));

      expect(values, contains(true));
      expect(values, contains(false));
    });

    test('recovers after failures', () async {
      int callCount = 0;
      final mockClient = MockClient((request) async {
        callCount++;
        if (callCount >= 2 && callCount <= 4) {
          return http.Response('error', 500);
        }
        return http.Response('ok', 200);
      });

      final container = ProviderContainer(
        overrides: [
          httpClientProvider.overrideWithValue(mockClient),
          reachabilityPollingIntervalProvider.overrideWithValue(Duration.zero),
        ],
      );
      addTearDown(container.dispose);

      final values = <bool>[];
      container.listen<AsyncValue<bool>>(
        backendReachabilityProvider,
        (prev, next) {
          next.whenData((v) => values.add(v));
        },
        fireImmediately: true,
      );

      await Future<void>.delayed(const Duration(milliseconds: 1000));

      // Expected sequence of reportedStatus: true, true (no yield), true (no yield), false (yield), true (yield)
      // So values should be [true, false, true]
      expect(values, [true, false, true]);
    });
  });
}
