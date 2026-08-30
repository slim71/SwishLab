import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:swish_lab/pages/credits.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:swish_lab/models/credit_item.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import '../test_helper.dart';

class MockAppStateNotifier extends AppStateNotifier {
  final AppState initialState;
  MockAppStateNotifier(this.initialState);

  @override
  AppState build() => initialState;

  @override
  void setCredits(List<Credit> credits) {
    state = state.copyWith(credits: credits);
  }
}

class MockUrlLauncher extends Mock with MockPlatformInterfaceMixin implements UrlLauncherPlatform {}

class FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(FakeLaunchOptions());
  });

  group('Credits', () {
    late MockUrlLauncher mockUrlLauncher;

    setUp(() {
      mockUrlLauncher = MockUrlLauncher();
      UrlLauncherPlatform.instance = mockUrlLauncher;
    });

    testWidgets('should render correctly with credits', (tester) async {
      final testCredits = [
        Credit(
          author: 'Test Author',
          url: 'https://example.com',
          asset: 'test_asset',
          type: 'font',
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            appStateProvider.overrideWith(() => MockAppStateNotifier(AppState(credits: testCredits))),
          ],
          child: const Credits(),
        ),
      );

      expect(find.text('Credits'), findsOneWidget);
      expect(find.text('Test Author'), findsOneWidget);

      // Test unfocus on background tap
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
    });

    testWidgets('should load credits if empty', (tester) async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets',
          (message) async {
        return utf8
            .encode(json.encode([
              {
                'author': 'Loaded Author',
                'url': 'https://asset.com',
                'asset': 'loaded_asset',
                'type': 'icon',
              }
            ]))
            .buffer
            .asByteData();
      });

      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(credits: <Credit>[]))),
          ],
          child: const Credits(),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Loaded Author'), findsOneWidget);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null);
    });

    testWidgets('should handle link taps', (tester) async {
      final testCredits = [
        Credit(
          author: 'Link Author',
          url: 'https://link.com',
          asset: 'asset',
          type: 'icon',
        ),
      ];

      when(() => mockUrlLauncher.launchUrl(any(), any())).thenAnswer((_) async => true);

      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            appStateProvider.overrideWith(() => MockAppStateNotifier(AppState(credits: testCredits))),
          ],
          child: const Credits(),
        ),
      );

      await tester.tap(find.text('Link Author'));
      await tester.pump();

      verify(() => mockUrlLauncher.launchUrl(any(), any())).called(1);
    });

    testWidgets('should handle fallback if launchUrl fails', (tester) async {
      final testCredits = [
        Credit(
          author: 'Fail Author',
          url: 'https://fail.com',
          asset: 'asset',
          type: 'icon',
        ),
      ];

      // First call returns false, second returns true
      when(() => mockUrlLauncher.launchUrl(any(), any())).thenAnswer((_) async => false);

      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            appStateProvider.overrideWith(() => MockAppStateNotifier(AppState(credits: testCredits))),
          ],
          child: const Credits(),
        ),
      );

      await tester.tap(find.text('Fail Author'));
      await tester.pump();

      // Should be called twice (primary + fallback)
      verify(() => mockUrlLauncher.launchUrl(any(), any())).called(2);
    });

    testWidgets('should show snackbar on error', (tester) async {
      final testCredits = [
        Credit(
          author: 'Error Author',
          url: 'https://error.com',
          asset: 'asset',
          type: 'icon',
        ),
      ];

      when(() => mockUrlLauncher.launchUrl(any(), any())).thenThrow(Exception('Launch failed'));

      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            appStateProvider.overrideWith(() => MockAppStateNotifier(AppState(credits: testCredits))),
          ],
          child: const Credits(),
        ),
      );

      await tester.tap(find.text('Error Author'));
      await tester.pump(); // Start navigation/throw
      await tester.pump(); // Show snackbar

      expect(find.textContaining('Error: Exception: Launch failed'), findsOneWidget);
    });

    testWidgets('should do nothing if url is empty', (tester) async {
      final testCredits = [
        Credit(
          author: 'Empty Author',
          url: '',
          asset: 'asset',
          type: 'icon',
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            appStateProvider.overrideWith(() => MockAppStateNotifier(AppState(credits: testCredits))),
          ],
          child: const Credits(),
        ),
      );

      await tester.tap(find.text('Empty Author'));
      await tester.pump();

      verifyNever(() => mockUrlLauncher.launchUrl(any(), any()));
    });
  });
}
