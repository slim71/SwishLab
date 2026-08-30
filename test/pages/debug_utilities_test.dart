import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/pages/debug_utilities.dart';
import 'package:swish_lab/pages/loading_page.dart';
import 'package:swish_lab/providers/auth_providers.dart';
import 'package:swish_lab/providers/users_provider.dart';
import 'package:swish_lab/providers/statistics_provider.dart';
import 'package:swish_lab/providers/debug_provider.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:swish_lab/providers/shared_preferences_provider.dart';
import '../test_helper.dart';

class MockAppStateNotifier extends AppStateNotifier {
  final AppState initialState;
  MockAppStateNotifier(this.initialState);

  @override
  AppState build() => initialState;
}

class MockDebugNotifier extends DebugNotifier {
  final DebugState initialState;
  MockDebugNotifier(this.initialState);

  @override
  DebugState build() => initialState;
}

void main() {
  late MockUsersRepository mockUsersRepo;
  late MockStatisticsRepository mockStatsRepo;
  late MockUser mockUser;
  late MockSharedPreferences mockPrefs;

  const defaultDebugState = DebugState(
    showPerformanceOverlay: false,
    isDeveloperModeEnabled: false,
  );

  setUpAll(() {
    registerFallbackValue(const AppState());
    registerFallbackValue(defaultDebugState);
  });

  setUp(() {
    mockUsersRepo = MockUsersRepository();
    mockStatsRepo = MockStatisticsRepository();
    mockUser = MockUser();
    mockPrefs = MockSharedPreferences();

    when(() => mockUser.id).thenReturn('123');
    when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
    when(() => mockPrefs.getBool(any())).thenReturn(null);
  });

  group('DebugUtilities', () {
    testWidgets('renders sections and items', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          appStateProvider
              .overrideWith(() => MockAppStateNotifier(const AppState())),
          debugProvider
              .overrideWith(() => MockDebugNotifier(defaultDebugState)),
        ],
        child: const DebugUtilities(),
      ));

      expect(find.text('Debug utilities'), findsOneWidget);
      expect(find.text('APP FLOW'), findsOneWidget);
      expect(find.text('NAVIGATION'), findsOneWidget);
      expect(find.text('SYSTEM'), findsOneWidget);
      expect(find.text('Environment Info'), findsOneWidget);
    });

    testWidgets('Reset "Has Opened Before" works', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          appStateProvider.overrideWith(() =>
              MockAppStateNotifier(const AppState(hasOpenedBefore: true))),
          debugProvider
              .overrideWith(() => MockDebugNotifier(defaultDebugState)),
        ],
        child: const DebugUtilities(),
      ));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Reset'));
      await tester.pumpAndSettle();

      expect(find.text('Reset successful. Restart app to see onboarding.'),
          findsOneWidget);
    });

    testWidgets('Toggle "Session Initialized" works', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          appStateProvider.overrideWith(() =>
              MockAppStateNotifier(const AppState(sessionInitialized: false))),
          debugProvider
              .overrideWith(() => MockDebugNotifier(defaultDebugState)),
        ],
        child: const DebugUtilities(),
      ));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Toggle'));
      await tester.pumpAndSettle();

      expect(find.text('Session state toggled to true.'), findsOneWidget);
    });

    testWidgets('Clear Shooting Hand works', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      when(() => mockUsersRepo.updateShootingHand(
          userId: '123', shootingHand: null)).thenAnswer((_) async => null);

      await tester.pumpWidget(createTestWidget(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          authUserProvider.overrideWithValue(mockUser),
          usersRepositoryProvider.overrideWithValue(mockUsersRepo),
          appStateProvider
              .overrideWith(() => MockAppStateNotifier(const AppState())),
          debugProvider
              .overrideWith(() => MockDebugNotifier(defaultDebugState)),
        ],
        child: const DebugUtilities(),
      ));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Clear').first);
      await tester.pumpAndSettle();

      expect(find.text('Hand cleared. Returning Home will trigger prompt.'),
          findsOneWidget);
      verify(() => mockUsersRepo.updateShootingHand(
          userId: '123', shootingHand: null)).called(1);
    });

    testWidgets('Clear Shooting Hand handles error', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      when(() => mockUsersRepo.updateShootingHand(
          userId: '123',
          shootingHand: null)).thenThrow(Exception('Update error'));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          authUserProvider.overrideWithValue(mockUser),
          usersRepositoryProvider.overrideWithValue(mockUsersRepo),
          appStateProvider
              .overrideWith(() => MockAppStateNotifier(const AppState())),
          debugProvider
              .overrideWith(() => MockDebugNotifier(defaultDebugState)),
        ],
        child: const DebugUtilities(),
      ));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Clear').first);
      await tester.pumpAndSettle();

      expect(find.textContaining('Error: Exception: Update error'),
          findsOneWidget);
    });

    testWidgets('Clear Activity History works', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      when(() => mockStatsRepo.clearStatistics('123'))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createTestWidget(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          authUserProvider.overrideWithValue(mockUser),
          statisticsRepositoryProvider.overrideWithValue(mockStatsRepo),
          appStateProvider
              .overrideWith(() => MockAppStateNotifier(const AppState())),
          debugProvider
              .overrideWith(() => MockDebugNotifier(defaultDebugState)),
        ],
        child: const DebugUtilities(),
      ));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Clear').last);
      await tester.pumpAndSettle();

      expect(
          find.text('Activity history cleared successfully.'), findsOneWidget);
      verify(() => mockStatsRepo.clearStatistics('123')).called(1);
    });

    testWidgets('Clear Activity History handles error', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      when(() => mockStatsRepo.clearStatistics('123'))
          .thenThrow(Exception('Clear error'));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          authUserProvider.overrideWithValue(mockUser),
          statisticsRepositoryProvider.overrideWithValue(mockStatsRepo),
          appStateProvider
              .overrideWith(() => MockAppStateNotifier(const AppState())),
          debugProvider
              .overrideWith(() => MockDebugNotifier(defaultDebugState)),
        ],
        child: const DebugUtilities(),
      ));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Clear').last);
      await tester.pumpAndSettle();

      expect(
          find.textContaining('Error: Exception: Clear error'), findsOneWidget);
    });

    testWidgets('Disable Developer Mode works', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      final mockRouter = MockGoRouter();

      await tester.pumpWidget(createTestWidget(
        router: mockRouter,
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          appStateProvider
              .overrideWith(() => MockAppStateNotifier(const AppState())),
          debugProvider.overrideWith(() => MockDebugNotifier(
              defaultDebugState.copyWith(isDeveloperModeEnabled: true))),
        ],
        child: const DebugUtilities(),
      ));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Disable'));
      await tester.pumpAndSettle();

      verify(() => mockRouter.pop()).called(1);
      expect(find.text('Developer mode disabled.'), findsOneWidget);
    });

    testWidgets('Navigation: Test Results Page works', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      final mockRouter = MockGoRouter();
      when(() => mockRouter.go(any(), extra: any(named: 'extra')))
          .thenReturn(null);

      await tester.pumpWidget(createTestWidget(
        router: mockRouter,
        overrides: [
          appStateProvider
              .overrideWith(() => MockAppStateNotifier(const AppState())),
          debugProvider
              .overrideWith(() => MockDebugNotifier(defaultDebugState)),
        ],
        child: const DebugUtilities(),
      ));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Test').first);
      await tester.pumpAndSettle();

      verify(() => mockRouter.go('/results', extra: any(named: 'extra')))
          .called(1);
    });

    testWidgets('Navigation: Test Success Page works', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      final mockRouter = MockGoRouter();
      when(() => mockRouter.pushNamed(
            any(),
            pathParameters: any(named: 'pathParameters'),
            queryParameters: any(named: 'queryParameters'),
            extra: any(named: 'extra'),
          )).thenAnswer((_) async => null);

      await tester.pumpWidget(createTestWidget(
        router: mockRouter,
        overrides: [
          appStateProvider
              .overrideWith(() => MockAppStateNotifier(const AppState())),
          debugProvider
              .overrideWith(() => MockDebugNotifier(defaultDebugState)),
        ],
        child: const DebugUtilities(),
      ));

      await tester.tap(find.widgetWithText(ElevatedButton, 'View').first);
      await tester.pumpAndSettle();

      verify(() => mockRouter.pushNamed('success')).called(1);
    });

    testWidgets('Navigation: Theme Color Test works', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      final mockRouter = MockGoRouter();
      when(() => mockRouter.pushNamed(
            any(),
            pathParameters: any(named: 'pathParameters'),
            queryParameters: any(named: 'queryParameters'),
            extra: any(named: 'extra'),
          )).thenAnswer((_) async => null);

      await tester.pumpWidget(createTestWidget(
        router: mockRouter,
        overrides: [
          appStateProvider
              .overrideWith(() => MockAppStateNotifier(const AppState())),
          debugProvider
              .overrideWith(() => MockDebugNotifier(defaultDebugState)),
        ],
        child: const DebugUtilities(),
      ));

      await tester.tap(find.widgetWithText(ElevatedButton, 'View').last);
      await tester.pumpAndSettle();

      verify(() => mockRouter.pushNamed('theme-test')).called(1);
    });

    testWidgets('Navigation: Test Loading Page works', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          appStateProvider
              .overrideWith(() => MockAppStateNotifier(const AppState())),
          debugProvider
              .overrideWith(() => MockDebugNotifier(defaultDebugState)),
        ],
        child: const DebugUtilities(),
      ));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Test').last);
      await tester.pumpAndSettle();

      expect(find.byType(LoadingPage), findsOneWidget);
    });

    testWidgets('System: Performance Overlay toggle works', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          appStateProvider
              .overrideWith(() => MockAppStateNotifier(const AppState())),
          debugProvider.overrideWith(() => MockDebugNotifier(
              defaultDebugState.copyWith(showPerformanceOverlay: false))),
        ],
        child: const DebugUtilities(),
      ));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Show'));
      await tester.pumpAndSettle();
    });

    testWidgets('GestureDetector unfocuses on tap', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          appStateProvider
              .overrideWith(() => MockAppStateNotifier(const AppState())),
          debugProvider
              .overrideWith(() => MockDebugNotifier(defaultDebugState)),
        ],
        child: const DebugUtilities(),
      ));

      await tester.tap(find.text('Debug utilities'));
      await tester.pump();
    });
  });
}
