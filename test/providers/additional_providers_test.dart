import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swish_lab/providers/storage_providers.dart';
import 'package:swish_lab/providers/feedback_provider.dart';
import 'package:swish_lab/providers/session.dart';
import 'package:swish_lab/providers/statistics_provider.dart';
import 'package:swish_lab/providers/debug_provider.dart';
import 'package:swish_lab/providers/users_provider.dart';
import 'package:swish_lab/providers/supabase_provider.dart';
import 'package:swish_lab/providers/shared_preferences_provider.dart';
import 'package:swish_lab/providers/auth_providers.dart';
import 'package:swish_lab/models/users_row.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:swish_lab/repositories/statistics_repository.dart';
import 'package:swish_lab/repositories/users_repository.dart';
import 'package:swish_lab/models/user_row_data.dart';
import '../test_helper.dart';
import '../supabase_mock.dart' hide MockUser;

class MockAppStateNotifier extends AppStateNotifier {
  final AppState initialState;
  MockAppStateNotifier(this.initialState);

  @override
  AppState build() => initialState;

  @override
  void setUserData(UserRowData data) {
    state = state.copyWith(userData: data, userDataFetched: true);
  }

  @override
  void reset() {
    state = initialState;
  }
}

class MockStatisticsRepository extends Mock implements StatisticsRepository {}

class MockUsersRepository extends Mock implements UsersRepository {}

void main() {
  late MockSupabaseClient mockSupabase;
  late MockGoTrueClient mockAuth;
  late MockSharedPreferences mockPrefs;

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockPrefs = MockSharedPreferences();
    when(() => mockSupabase.auth).thenReturn(mockAuth);
    when(() => mockPrefs.getBool(any<String>())).thenReturn(null);
    when(() => mockPrefs.setBool(any<String>(), any<bool>())).thenAnswer((_) async => true);
    when(() => mockPrefs.setString(any<String>(), any<String>())).thenAnswer((_) async => true);
    when(() => mockPrefs.getString(any<String>())).thenReturn(null);
  });

  group('Storage Providers', () {
    test('storageRepositoryProvider creates a StorageRepository', () {
      final container = createContainer(overrides: [
        supabaseProvider.overrideWithValue(mockSupabase),
      ]);
      expect(container.read(storageRepositoryProvider), isNotNull);
    });
  });

  group('Feedback Provider', () {
    final List<Map<String, dynamic>> templates = [
      <String, dynamic>{
        'section': 'Jump',
        'scores': [
          <String, dynamic>{
            'name': 'Total',
            'ranges': [
              <String, dynamic>{'min': 0.0, 'max': 0.5, 'feedback': 'Low Jump'},
              <String, dynamic>{'min': 0.51, 'max': 1.0, 'feedback': 'High Jump'},
            ]
          }
        ]
      }
    ];

    test('getFeedbackForScore returns correct feedback', () {
      final high = getFeedbackForScore(templates: templates, sectionName: 'Jump', scoreName: 'Total', scoreValue: 0.8);
      expect(high, 'High Jump');

      final low = getFeedbackForScore(templates: templates, sectionName: 'Jump', scoreName: 'Total', scoreValue: 0.3);
      expect(low, 'Low Jump');
    });

    test('getFeedbackForScore returns default if section not found', () {
      final result =
          getFeedbackForScore(templates: templates, sectionName: 'None', scoreName: 'Total', scoreValue: 0.8);
      expect(result, contains('Great work'));
    });

    test('getFeedbackForScore returns default if score not found', () {
      final result =
          getFeedbackForScore(templates: templates, sectionName: 'Jump', scoreName: 'Unknown', scoreValue: 0.8);
      expect(result, 'High Jump');
    });

    test('getFeedbackForScore returns fallback if score and total are both missing', () {
      final templatesWithoutTotal = [
        <String, dynamic>{
          'section': 'Jump',
          'scores': [
            <String, dynamic>{
              'name': 'NotTotal',
              'ranges': [
                <String, dynamic>{'min': 0.0, 'max': 1.0, 'feedback': 'Some Jump'}
              ]
            }
          ]
        }
      ];
      final result = getFeedbackForScore(
          templates: templatesWithoutTotal, sectionName: 'Jump', scoreName: 'Unknown', scoreValue: 0.8);
      expect(result, 'Keep practicing your Jump Unknown!');
    });

    test('getFeedbackForScore returns final default if no range matches', () {
      final result =
          getFeedbackForScore(templates: templates, sectionName: 'Jump', scoreName: 'Total', scoreValue: 2.0);
      expect(result, contains('Analysis complete'));
    });

    test('getFeedbackForScore handles errors gracefully', () {
      final List<dynamic> invalidTemplates = [null];
      final result = getFeedbackForScore(
          templates: invalidTemplates.cast<Map<String, dynamic>>(),
          sectionName: 'Error',
          scoreName: '',
          scoreValue: 0.0);
      expect(result, contains('Keep up the good work'));
    });

    test('feedbackProvider loads successfully', () async {
      final container = createContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
      ]);
      final result = await container.read(feedbackProvider.future);
      expect(result, isNotEmpty);
    });
  });

  group('Session Providers', () {
    test('verifiedSessionProvider returns current session', () async {
      final mockSession = MockSession();
      when(() => mockAuth.currentSession).thenReturn(mockSession);

      final container = createContainer(overrides: [
        supabaseProvider.overrideWithValue(mockSupabase),
      ]);

      final result = await container.read(verifiedSessionProvider.future);
      expect(result, mockSession);
    });

    testWidgets('sessionBootstrapProvider syncs data to appState', (tester) async {
      final user = UsersRow(id: '1', firstName: 'F', lastName: 'L', email: 'e', createdAt: DateTime.now());

      final container = createContainer(overrides: [
        appUserProvider.overrideWith((ref) => user),
        appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(userData: null))),
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
        supabaseProvider.overrideWithValue(mockSupabase),
      ]);

      container.read(sessionBootstrapProvider);

      await tester.pump(const Duration(milliseconds: 100));

      final appState = container.read(appStateProvider);
      expect(appState.userData?.userID, '1');
    });

    testWidgets('sessionBootstrapProvider does nothing if user is null', (tester) async {
      final container = createContainer(overrides: [
        appUserProvider.overrideWith((ref) => null),
        appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(userData: null))),
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
        supabaseProvider.overrideWithValue(mockSupabase),
      ]);

      container.read(sessionBootstrapProvider);
      await tester.pump(const Duration(milliseconds: 100));

      final appState = container.read(appStateProvider);
      expect(appState.userData, isNull);
    });
  });

  group('Statistics Provider', () {
    test('statisticsRepositoryProvider creates repository', () {
      final container = createContainer(overrides: [
        supabaseProvider.overrideWithValue(mockSupabase),
      ]);
      expect(container.read(statisticsRepositoryProvider), isNotNull);
    });

    test('userStatisticsProvider returns empty if user is null', () async {
      final container = createContainer(overrides: [
        appUserProvider.overrideWith((ref) => null),
        supabaseProvider.overrideWithValue(mockSupabase),
      ]);

      // Wait for initialization
      final state = await container.read(userStatisticsProvider.notifier).stream.first;
      final result = state.value!;
      expect(result.items, isEmpty);
      expect(result.totalCount, 0);
      expect(result.hasMore, isFalse);
    });

    test('userStatisticsProvider returns stats for user', () async {
      final user = const UsersRow(id: '1', firstName: 'F', lastName: 'L', email: 'e');
      final mockRepo = MockStatisticsRepository();
      when(() => mockRepo.getUserStatistics('1', limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer((_) async => []);
      when(() => mockRepo.getStatsCount('1')).thenAnswer((_) async => 0);

      final container = createContainer(overrides: [
        appUserProvider.overrideWith((ref) => user),
        statisticsRepositoryProvider.overrideWithValue(mockRepo),
        supabaseProvider.overrideWithValue(mockSupabase),
      ]);

      // Wait for initialization
      final state = await container.read(userStatisticsProvider.notifier).stream.first;
      final result = state.value!;
      expect(result.items, isEmpty);
      expect(result.totalCount, 0);
      verify(() => mockRepo.getUserStatistics('1', limit: any(named: 'limit'))).called(1);
    });
  });

  group('Debug Provider', () {
    test('DebugNotifier toggles overlay', () {
      final container = createContainer();
      final notifier = container.read(debugProvider.notifier);

      expect(container.read(debugProvider).showPerformanceOverlay, false);
      notifier.togglePerformanceOverlay();
      expect(container.read(debugProvider).showPerformanceOverlay, true);
    });

    test('DebugNotifier sets developer mode', () {
      final container = createContainer();
      final notifier = container.read(debugProvider.notifier);

      expect(container.read(debugProvider).isDeveloperModeEnabled, false);
      notifier.setDeveloperMode(true);
      expect(container.read(debugProvider).isDeveloperModeEnabled, true);
    });

    test('DebugNotifier reset works', () async {
      final container = createContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
      ]);

      final notifier = container.read(debugProvider.notifier);
      notifier.setDeveloperMode(true);
      await notifier.reset();

      expect(container.read(debugProvider).isDeveloperModeEnabled, false);
      verify(() => mockPrefs.setBool(any(), false)).called(1);
    });
  });

  group('Users Provider', () {
    test('usersRepositoryProvider creates repository', () {
      final container = createContainer(overrides: [
        supabaseProvider.overrideWithValue(mockSupabase),
      ]);
      expect(container.read(usersRepositoryProvider), isNotNull);
    });

    test('appUserProvider returns null if auth user is null', () async {
      final container = createContainer(overrides: [
        supabaseProvider.overrideWithValue(mockSupabase),
        authUserProvider.overrideWithValue(null),
      ]);

      final result = await container.read(appUserProvider.future);
      expect(result, isNull);
    });

    test('appUserProvider returns user data', () async {
      final mockUser = MockUser();
      when(() => mockUser.id).thenReturn('1');
      final mockRepo = MockUsersRepository();
      final userRow = const UsersRow(id: '1', firstName: 'F', lastName: 'L', email: 'e');
      when(() => mockRepo.getUserRow('1')).thenAnswer((_) async => userRow);

      final container = createContainer(overrides: [
        supabaseProvider.overrideWithValue(mockSupabase),
        authUserProvider.overrideWithValue(mockUser),
        usersRepositoryProvider.overrideWithValue(mockRepo),
      ]);

      final result = await container.read(appUserProvider.future);
      expect(result, userRow);
    });

    test('updateUserProvider and changeProfilePictureProvider create objects', () {
      final container = createContainer(overrides: [
        supabaseProvider.overrideWithValue(mockSupabase),
      ]);
      expect(container.read(updateUserProvider), isNotNull);
      expect(container.read(changeProfilePictureProvider), isNotNull);
    });
  });

  group('Supabase Provider', () {
    test('supabaseProvider returns client (overridden)', () {
      final container = createContainer(overrides: [
        supabaseProvider.overrideWithValue(mockSupabase),
      ]);
      expect(container.read(supabaseProvider), mockSupabase);
    });

    testWidgets('supabaseAuthListenerProvider handles auth changes', (tester) async {
      final authStateController = StreamController<AuthState>();
      when(() => mockAuth.onAuthStateChange).thenAnswer((_) => authStateController.stream);
      when(() => mockAuth.currentSession).thenReturn(null);

      final container = createContainer(overrides: [
        supabaseProvider.overrideWithValue(mockSupabase),
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
        appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
      ]);

      container.read(supabaseAuthListenerProvider);

      // Wait for the microtask in supabaseAuthListenerProvider to complete
      await tester.pump(Duration.zero);
      expect(container.read(appAuthStatusProvider), AppAuthStatus.unauthenticated);

      final mockSession = MockSession();
      when(() => mockSession.accessToken).thenReturn('token');
      authStateController.add(AuthState(AuthChangeEvent.signedIn, mockSession));
      // Listener uses listen() which might also trigger async updates
      await tester.pump(Duration.zero);
      expect(container.read(appAuthStatusProvider), AppAuthStatus.authenticated);

      authStateController.add(const AuthState(AuthChangeEvent.signedOut, null));
      await tester.pump(Duration.zero);
      expect(container.read(appAuthStatusProvider), AppAuthStatus.unauthenticated);

      await authStateController.close();
    });

    testWidgets('supabaseAuthListenerProvider handles initial session', (tester) async {
      final mockSession = MockSession();
      when(() => mockSession.accessToken).thenReturn('token');
      when(() => mockAuth.currentSession).thenReturn(mockSession);
      when(() => mockAuth.onAuthStateChange).thenAnswer((_) => const Stream.empty());

      final container = createContainer(overrides: [
        supabaseProvider.overrideWithValue(mockSupabase),
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
        appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
      ]);

      container.read(supabaseAuthListenerProvider);
      await tester.pump(Duration.zero);
      expect(container.read(appAuthStatusProvider), AppAuthStatus.authenticated);
    });

    testWidgets('supabaseAuthListenerProvider handles errors during init', (tester) async {
      when(() => mockAuth.currentSession).thenThrow(Exception('Auth error'));
      when(() => mockAuth.onAuthStateChange).thenAnswer((_) => const Stream.empty());

      final container = createContainer(overrides: [
        supabaseProvider.overrideWithValue(mockSupabase),
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
        appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
      ]);

      container.read(supabaseAuthListenerProvider);
      await tester.pump(Duration.zero);
      expect(container.read(appAuthStatusProvider), AppAuthStatus.offline);
    });
  });

  group('Shared Preferences Provider', () {
    test('throws error if not overridden', () {
      final container = ProviderContainer();
      expect(() => container.read(sharedPreferencesProvider), throwsA(anything));
    });
  });
}
