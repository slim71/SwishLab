import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/models/credit_item.dart';
import 'package:swish_lab/models/user_row_data.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:swish_lab/providers/shared_preferences_provider.dart';
import '../test_helper.dart';

void main() {
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();

    // Default mock behaviors
    when(() => mockPrefs.getBool(any())).thenReturn(null);
    when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
  });

  group('AppState', () {
    test('constructor has default values', () {
      const state = AppState();
      expect(state.hasOpenedBefore, false);
      expect(state.userDataFetched, false);
      expect(state.userData, const UserRowData());
      expect(state.credits, const []);
      expect(state.loadedFaqs, isNull);
      expect(state.sessionInitialized, false);
      expect(state.showRadarChart, true);
    });

    test('copyWith creates a new instance with updated values', () {
      const state = AppState();
      final updatedUser = const UserRowData(userID: '123');
      final updatedCredits = [Credit(author: 'A', url: 'U', asset: 'As', type: 'T')];
      final updatedFaqs = [
        {'q': 'a'}
      ];

      final newState = state.copyWith(
        hasOpenedBefore: true,
        userDataFetched: true,
        userData: updatedUser,
        credits: updatedCredits,
        loadedFaqs: updatedFaqs,
        sessionInitialized: true,
        showRadarChart: false,
      );

      expect(newState.hasOpenedBefore, true);
      expect(newState.userDataFetched, true);
      expect(newState.userData, updatedUser);
      expect(newState.credits, updatedCredits);
      expect(newState.loadedFaqs, updatedFaqs);
      expect(newState.sessionInitialized, true);
      expect(newState.showRadarChart, false);
    });

    test('copyWith preserves values when parameters are null', () {
      const state = AppState(hasOpenedBefore: true);
      final newState = state.copyWith();
      expect(newState.hasOpenedBefore, true);
    });
  });

  group('AppStateNotifier', () {
    test('initial state builds from SharedPreferences', () {
      when(() => mockPrefs.getBool('hasOpenedBefore')).thenReturn(true);
      when(() => mockPrefs.getBool('showRadarChart')).thenReturn(false);

      final container = createContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
      ]);

      final state = container.read(appStateProvider);

      expect(state.hasOpenedBefore, true);
      expect(state.showRadarChart, false);
    });

    test('initial state uses defaults if SharedPreferences are null', () {
      when(() => mockPrefs.getBool(any())).thenReturn(null);

      final container = createContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
      ]);

      final state = container.read(appStateProvider);

      expect(state.hasOpenedBefore, false);
      expect(state.showRadarChart, true);
    });

    test('setHasOpenedBefore updates state and SharedPreferences', () async {
      final container = createContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
      ]);

      container.read(appStateProvider.notifier).setHasOpenedBefore(true);

      expect(container.read(appStateProvider).hasOpenedBefore, true);
      verify(() => mockPrefs.setBool('hasOpenedBefore', true)).called(1);
    });

    test('setShowRadarChart updates state and SharedPreferences', () async {
      final container = createContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
      ]);

      container.read(appStateProvider.notifier).setShowRadarChart(false);

      expect(container.read(appStateProvider).showRadarChart, false);
      verify(() => mockPrefs.setBool('showRadarChart', false)).called(1);
    });

    test('setUserDataFetched updates state', () {
      final container = createContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
      ]);

      container.read(appStateProvider.notifier).setUserDataFetched(true);
      expect(container.read(appStateProvider).userDataFetched, true);
    });

    test('setUserData updates state and sets userDataFetched to true', () {
      final container = createContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
      ]);
      final userData = const UserRowData(userID: 'user1');

      container.read(appStateProvider.notifier).setUserData(userData);

      final state = container.read(appStateProvider);
      expect(state.userData, userData);
      expect(state.userDataFetched, true);
    });

    test('setCredits updates state', () {
      final container = createContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
      ]);
      final credits = [Credit(author: 'A', url: 'U', asset: 'As', type: 'T')];

      container.read(appStateProvider.notifier).setCredits(credits);
      expect(container.read(appStateProvider).credits, credits);
    });

    test('setLoadedFaqs updates state', () {
      final container = createContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
      ]);
      final faqs = [
        {'question': 'answer'}
      ];

      container.read(appStateProvider.notifier).setLoadedFaqs(faqs);
      expect(container.read(appStateProvider).loadedFaqs, faqs);
    });

    test('setSessionInitialized updates state', () {
      final container = createContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
      ]);

      container.read(appStateProvider.notifier).setSessionInitialized(true);
      expect(container.read(appStateProvider).sessionInitialized, true);
    });

    test('reset clears state but preserves hasOpenedBefore from SharedPreferences', () {
      when(() => mockPrefs.getBool('hasOpenedBefore')).thenReturn(true);

      final container = createContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
      ]);

      // Set some values
      final notifier = container.read(appStateProvider.notifier);
      notifier.setShowRadarChart(false);
      notifier.setUserDataFetched(true);

      notifier.reset();

      final state = container.read(appStateProvider);
      expect(state.hasOpenedBefore, true);
      expect(state.showRadarChart, true); // Reset to default
      expect(state.userDataFetched, false); // Reset to default
    });
  });
}
