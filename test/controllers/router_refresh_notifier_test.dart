import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/controllers/router_refresh_notifier.dart';
import 'package:swish_lab/providers/auth_providers.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:swish_lab/providers/shared_preferences_provider.dart';

import '../test_helper.dart';

void main() {
  late ProviderContainer container;
  late RouterRefreshNotifier notifier;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    when(() => mockPrefs.getBool(any())).thenReturn(false);
    when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);

    container = createContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
      ],
    );
    notifier = container.read(routerRefreshProvider);
  });

  group('RouterRefreshNotifier', () {
    test('notifies listeners when auth status changes', () async {
      final statusController = StateProvider<AppAuthStatus>((ref) => AppAuthStatus.loading);

      container = createContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          appStatusProvider.overrideWith((ref) => ref.watch(statusController)),
        ],
      );

      // We use container.listen to ensure the provider is actively watched by the container,
      // which ensures ref.listen internal callbacks are correctly triggered in a test environment.
      container.listen(routerRefreshProvider, (_, __) {});
      notifier = container.read(routerRefreshProvider);

      // Ensure appStatusProvider is initialized
      expect(container.read(appStatusProvider), AppAuthStatus.loading);

      bool notified = false;
      notifier.addListener(() => notified = true);

      // Trigger change
      container.read(statusController.notifier).state = AppAuthStatus.authenticated;

      // Wait for microtasks to ensure the listener callback has been executed
      await pumpEventQueue();

      expect(notified, isTrue);
    });

    test('notifies listeners when onboarding state changes', () async {
      bool notified = false;
      notifier.addListener(() => notified = true);

      // appStateProvider is a NotifierProvider, calling setHasOpenedBefore triggers a state change
      container.read(appStateProvider.notifier).setHasOpenedBefore(true);

      await pumpEventQueue();
      expect(notified, isTrue);
    });

    test('does not notify listeners if onboarding state hasOpenedBefore is the same', () async {
      bool notified = false;
      notifier.addListener(() => notified = true);

      // Current state is false (from mockPrefs returning false), setting it to false again
      container.read(appStateProvider.notifier).setHasOpenedBefore(false);

      await pumpEventQueue();
      expect(notified, isFalse);
    });
  });
}
