import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/providers/debug_provider.dart';
import 'package:swish_lab/providers/shared_preferences_provider.dart';
import '../test_helper.dart';

void main() {
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
  });

  group('DebugProvider', () {
    test('initial state is correct', () {
      final container = createContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
      );

      final state = container.read(debugProvider);
      expect(state.showPerformanceOverlay, isFalse);
      expect(state.isDeveloperModeEnabled, isFalse);
    });

    test('togglePerformanceOverlay changes state', () {
      final container = createContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
      );

      container.read(debugProvider.notifier).togglePerformanceOverlay();
      expect(container.read(debugProvider).showPerformanceOverlay, isTrue);

      container.read(debugProvider.notifier).togglePerformanceOverlay();
      expect(container.read(debugProvider).showPerformanceOverlay, isFalse);
    });

    test('setDeveloperMode changes state', () {
      final container = createContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
      );

      container.read(debugProvider.notifier).setDeveloperMode(true);
      expect(container.read(debugProvider).isDeveloperModeEnabled, isTrue);

      container.read(debugProvider.notifier).setDeveloperMode(false);
      expect(container.read(debugProvider).isDeveloperModeEnabled, isFalse);
    });

    test('reset clears state and updates shared preferences', () async {
      when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);

      final container = createContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
      );

      // Set some state first
      container.read(debugProvider.notifier).setDeveloperMode(true);
      container.read(debugProvider.notifier).togglePerformanceOverlay();

      expect(container.read(debugProvider).isDeveloperModeEnabled, isTrue);
      expect(container.read(debugProvider).showPerformanceOverlay, isTrue);

      await container.read(debugProvider.notifier).reset();

      final state = container.read(debugProvider);
      expect(state.isDeveloperModeEnabled, isFalse);
      expect(state.showPerformanceOverlay, isFalse);

      verify(() => mockPrefs.setBool('isDeveloperModeEnabled', false)).called(1);
    });

    test('DebugState copyWith works correctly', () {
      const state = DebugState(showPerformanceOverlay: false, isDeveloperModeEnabled: false);

      final copy1 = state.copyWith(showPerformanceOverlay: true);
      expect(copy1.showPerformanceOverlay, isTrue);
      expect(copy1.isDeveloperModeEnabled, isFalse);

      final copy2 = state.copyWith(isDeveloperModeEnabled: true);
      expect(copy2.showPerformanceOverlay, isFalse);
      expect(copy2.isDeveloperModeEnabled, isTrue);

      final copy3 = state.copyWith(showPerformanceOverlay: true, isDeveloperModeEnabled: true);
      expect(copy3.showPerformanceOverlay, isTrue);
      expect(copy3.isDeveloperModeEnabled, isTrue);

      final copy4 = state.copyWith();
      expect(copy4.showPerformanceOverlay, isFalse);
      expect(copy4.isDeveloperModeEnabled, isFalse);
    });
    group('Notifier initialization', () {
      test('build() logs and returns default state', () {
        // This is mainly for coverage of the build method and its logging
        final container = createContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
          ],
        );
        final state = container.read(debugProvider);
        expect(state.showPerformanceOverlay, isFalse);
      });
    });
  });
}
