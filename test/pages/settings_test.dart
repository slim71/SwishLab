import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swish_lab/pages/settings.dart';
import 'package:swish_lab/providers/auth_providers.dart';
import 'package:swish_lab/providers/debug_provider.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:swish_lab/providers/shared_preferences_provider.dart';
import 'package:swish_lab/widgets/social_icon_button.dart';
import '../test_helper.dart';

class MockAppStateNotifier extends AppStateNotifier {
  final AppState initialState;
  MockAppStateNotifier(this.initialState);

  @override
  AppState build() => initialState;

  @override
  void reset() {}

  @override
  void setLoadedFaqs(List<Map<String, dynamic>> faqs) {}
}

class MockDebugNotifier extends DebugNotifier {
  final DebugState initialState;
  MockDebugNotifier(this.initialState);

  @override
  DebugState build() => initialState;

  @override
  void setDeveloperMode(bool enabled) {}

  @override
  Future<void> reset() async {}
}

void main() {
  late MockAuthService mockAuthService;
  late MockGoRouter mockRouter;
  late MockSharedPreferences mockPrefs;

  const defaultDebugState = DebugState(
    showPerformanceOverlay: false,
    isDeveloperModeEnabled: false,
  );

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    registerFallbackValue(const AppState());
    registerFallbackValue(defaultDebugState);
  });

  setUp(() {
    mockAuthService = MockAuthService();
    mockRouter = MockGoRouter();
    mockPrefs = MockSharedPreferences();

    when(() => mockAuthService.signOut()).thenAnswer((_) async => {});
    when(() => mockRouter.pushNamed(
          any(),
          pathParameters: any(named: 'pathParameters'),
          queryParameters: any(named: 'queryParameters'),
          extra: any(named: 'extra'),
        )).thenAnswer((_) async => null);
  });

  group('Settings Page', () {
    testWidgets('enables developer mode after 10 taps on SwishLab', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
          debugProvider.overrideWith(() => DebugNotifier()), // Use real one to test state changes
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
        child: const Settings(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Debug utilities'), findsNothing);

      final swishLabText = find.text('SwishLab');
      for (int i = 0; i < 10; i++) {
        await tester.tap(swishLabText, warnIfMissed: false);
        await tester.pump();
      }
      await tester.pumpAndSettle();

      expect(find.text('Developer mode enabled!'), findsOneWidget);
      expect(find.text('Debug utilities'), findsOneWidget);
    });

    testWidgets('navigates to various pages', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(createTestWidget(
        router: mockRouter,
        overrides: [
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
          debugProvider.overrideWith(() => MockDebugNotifier(defaultDebugState.copyWith(isDeveloperModeEnabled: true))),
        ],
        child: const Settings(),
      ));
      await tester.pumpAndSettle();

      // Appearance
      await tester.tap(find.text('Appearance'));
      verify(() => mockRouter.pushNamed('appearance')).called(1);

      // User Info
      await tester.tap(find.text('User Info'));
      verify(() => mockRouter.pushNamed('user')).called(1);

      // Getting Started
      await tester.tap(find.text('Getting Started'));
      verify(() => mockRouter.pushNamed('getting-started')).called(1);

      // About Us
      await tester.tap(find.text('About Us'));
      verify(() => mockRouter.pushNamed('about')).called(1);

      // Help (triggers JSON load)
      await tester.tap(find.text('Help'));
      await tester.pumpAndSettle();
      verify(() => mockRouter.pushNamed('help')).called(1);

      // Credits
      await tester.tap(find.text('Credits'));
      verify(() => mockRouter.pushNamed('credits')).called(1);

      // Terms & Conditions
      await tester.tap(find.text('Terms & Conditions'));
      verify(() => mockRouter.pushNamed('document', pathParameters: {'name': 'TAC'})).called(1);

      // EULA
      await tester.tap(find.text('EULA'));
      verify(() => mockRouter.pushNamed('document', pathParameters: {'name': 'EULA'})).called(1);

      // Disclaimer
      await tester.tap(find.text('Disclaimer'));
      verify(() => mockRouter.pushNamed('document', pathParameters: {'name': 'DISCLAIMER'})).called(1);

      // Acceptable Use Policy
      await tester.tap(find.text('Acceptable Use Policy'));
      verify(() => mockRouter.pushNamed('document', pathParameters: {'name': 'USE'})).called(1);

      // Debug utilities
      await tester.tap(find.text('Debug utilities'));
      verify(() => mockRouter.pushNamed('debug')).called(1);
    });

    testWidgets('Logout process triggers services', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
          debugProvider.overrideWith(() => MockDebugNotifier(defaultDebugState)),
        ],
        child: const Settings(),
      ));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('Log Out'), 200);
      await tester.tap(find.text('Log Out'));
      await tester.pump();

      verify(() => mockAuthService.signOut()).called(1);
    });

    testWidgets('Social icons tap log debug info', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget(
        child: const Settings(),
      ));
      await tester.pumpAndSettle();

      // Just verify they are clickable
      await tester.tap(find.byType(SocialIconButton).at(0));
      await tester.tap(find.byType(SocialIconButton).at(1));
      await tester.tap(find.byType(SocialIconButton).at(2));
      await tester.pump();
    });
  });
}
