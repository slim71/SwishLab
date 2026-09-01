import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/framework.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swish_lab/models/statistics_row.dart';
import 'package:swish_lab/models/users_row.dart';
import 'package:swish_lab/pages/home_page.dart';
import 'package:swish_lab/providers/shared_preferences_provider.dart';
import 'package:swish_lab/providers/statistics_provider.dart';
import '../test_helper.dart';
import 'package:swish_lab/providers/users_provider.dart';
import 'package:swish_lab/state/app_state.dart';

class MockGoRouter extends Mock implements GoRouter {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

final List<int> transparentImage = [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
];

HttpClient createMockImageHttpClient() {
  final client = MockHttpClient();
  final request = MockHttpClientRequest();
  final response = MockHttpClientResponse();
  final headers = MockHttpHeaders();

  when(() => client.getUrl(any())).thenAnswer((_) async => request);
  when(() => request.headers).thenReturn(headers);
  when(() => request.close()).thenAnswer((_) async => response);
  when(() => response.statusCode).thenReturn(200);
  when(() => response.contentLength).thenReturn(transparentImage.length);
  when(() => response.compressionState).thenReturn(HttpClientResponseCompressionState.notCompressed);
  when(() => response.listen(any(),
      onError: any(named: 'onError'),
      onDone: any(named: 'onDone'),
      cancelOnError: any(named: 'cancelOnError'))).thenAnswer((invocation) {
    final onData = invocation.positionalArguments[0] as void Function(List<int>);
    final onDone = invocation.namedArguments[#onDone] as void Function()?;
    return Stream<List<int>>.fromIterable([transparentImage]).listen(onData, onDone: onDone);
  });
  return client;
}

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => createMockImageHttpClient();
}

/// Helper notifier to start the app with session already initialized
class InitializedAppStateNotifier extends AppStateNotifier {
  @override
  AppState build() {
    return super.build().copyWith(sessionInitialized: true);
  }
}

void main() {
  late MockGoRouter mockRouter;
  late MockSharedPreferences mockPrefs;
  late UsersRow mockUserWithHand;
  late UsersRow mockUserWithoutHand;
  late List<StatisticsRow> mockStats;

  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
    registerFallbackValue(const Offset(0, 0));
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockRouter = MockGoRouter();
    mockPrefs = MockSharedPreferences();

    mockUserWithHand = const UsersRow(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      shootingHand: 'Right',
    );
    mockUserWithoutHand = const UsersRow(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      shootingHand: null,
    );
    mockStats = [
      StatisticsRow(
        statId: 's1',
        userId: '1',
        createdAt: DateTime.now(),
        setPointTotalScore: 0.8,
        jumpTotalScore: 0.8,
        elbowPositionTotalScore: 0.8,
        feetDirectionTotalScore: 0.8,
        shotPathTotalScore: 0.8,
        followThroughTotalScore: 0.8,
      ),
    ];

    // Stub SharedPreferences
    when(() => mockPrefs.getBool(any())).thenReturn(null);
    when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);

    // Stub GoRouter methods
    when(() => mockRouter.goNamed(any(),
        pathParameters: any(named: 'pathParameters'),
        queryParameters: any(named: 'queryParameters'),
        extra: any(named: 'extra'))).thenReturn(null);
    when(() => mockRouter.pushNamed(any(),
        pathParameters: any(named: 'pathParameters'),
        queryParameters: any(named: 'queryParameters'),
        extra: any(named: 'extra'))).thenAnswer((_) async => null);
  });

  Widget createWidgetUnderTest({
    required List<Override> overrides,
  }) {
    return ProviderScope(
      overrides: List<Override>.from([
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ...overrides,
      ]),
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: mockRouter,
          child: const HomePage(),
        ),
      ),
    );
  }

  testWidgets('Shooting hand prompt appears if user has no shooting hand set', (tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(
        overrides: [
          appUserProvider.overrideWith((ref) => Future.value(mockUserWithoutHand)),
          userStatisticsProvider.overrideWith((ref) => MockUserStatisticsNotifier(
              ref, const AsyncValue.data(UserStatisticsState(items: [], totalCount: 0, hasMore: false)))),
        ],
      ),
    );

    // Initial pump
    await tester.pump();
    // Pump to allow the future to complete and listener to trigger
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Info needed'), findsOneWidget);
    expect(find.text('One quick step before you continue: tell us your shooting hand.'), findsOneWidget);
  });

  testWidgets('Hero card shows the user\'s first name and session count', (tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(
        overrides: [
          appUserProvider.overrideWith((ref) => mockUserWithHand),
          userStatisticsProvider.overrideWith((ref) => MockUserStatisticsNotifier(ref,
              AsyncValue.data(UserStatisticsState(items: mockStats, totalCount: mockStats.length, hasMore: false)))),
        ],
      ),
    );
    await tester.pump();

    // Set sessionInitialized to true
    final container = ProviderScope.containerOf(tester.element(find.byType(HomePage)));
    container.read(appStateProvider.notifier).setSessionInitialized(true);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('John'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Setup button in dialog navigates to user page', (tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(
        overrides: [
          appUserProvider.overrideWith((ref) => Future.value(mockUserWithoutHand)),
          userStatisticsProvider.overrideWith((ref) => MockUserStatisticsNotifier(
              ref, const AsyncValue.data(UserStatisticsState(items: [], totalCount: 0, hasMore: false)))),
        ],
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Ok'));
    await tester.pump(const Duration(milliseconds: 500));

    final container = ProviderScope.containerOf(tester.element(find.byType(HomePage)));
    expect(container.read(appStateProvider).sessionInitialized, isTrue);
    verify(() => mockRouter.goNamed('user')).called(1);
  });

  testWidgets('Setup button in red banner navigates to user page', (tester) async {
    // Set a larger surface size for this test to ensure the banner is hit-testable
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());

    // Banner is shown when hasShootingHand is false, but sessionInitialized is true
    await tester.pumpWidget(
      createWidgetUnderTest(
        overrides: [
          appUserProvider.overrideWith((ref) => mockUserWithoutHand),
          userStatisticsProvider.overrideWith((ref) => MockUserStatisticsNotifier(
              ref, const AsyncValue.data(UserStatisticsState(items: [], totalCount: 0, hasMore: false)))),
          // Skipping the dialog by initializing the session
          appStateProvider.overrideWith(() => InitializedAppStateNotifier()),
        ],
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('You can\'t use these yet - tell us your shooting hand first!'), findsOneWidget);

    await tester.tap(find.text('Setup'));
    await tester.pump(const Duration(milliseconds: 500));

    verify(() => mockRouter.pushNamed('user')).called(1);
  });

  testWidgets('Feature cards navigate when clicked and shooting hand is set', (tester) async {
    // Set a larger surface size for this test to ensure cards are visible and hit-testable
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());

    await tester.pumpWidget(
      createWidgetUnderTest(
        overrides: [
          appUserProvider.overrideWith((ref) => mockUserWithHand),
          userStatisticsProvider.overrideWith((ref) => MockUserStatisticsNotifier(ref,
              AsyncValue.data(UserStatisticsState(items: mockStats, totalCount: mockStats.length, hasMore: false)))),
        ],
      ),
    );
    await tester.pump();

    // Set sessionInitialized to true
    final container = ProviderScope.containerOf(tester.element(find.byType(HomePage)));
    container.read(appStateProvider.notifier).setSessionInitialized(true);
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Front View'));
    await tester.pump(const Duration(milliseconds: 500));
    verify(() => mockRouter.pushNamed('front')).called(1);

    await tester.tap(find.text('Side View'));
    await tester.pump(const Duration(milliseconds: 500));
    verify(() => mockRouter.pushNamed('side')).called(1);
  });
}
