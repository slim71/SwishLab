import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/pages/help.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:swish_lab/widgets/faq_item.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../test_helper.dart';

class MockAppStateNotifier extends AppStateNotifier {
  final AppState initialState;
  MockAppStateNotifier(this.initialState);

  @override
  AppState build() => initialState;
}

class MockUrlLauncher extends Mock with MockPlatformInterfaceMixin implements UrlLauncherPlatform {}

class FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  final List<Map<String, dynamic>> testFaqs = [
    {
      'question': 'How to shoot?',
      'answer': 'Just release the ball.',
      'order': 1,
    },
    {
      'question': 'How to jump?',
      'answer': 'Use your legs.',
      'order': 2,
    },
  ];

  late MockUrlLauncher mockUrlLauncher;

  setUpAll(() {
    registerFallbackValue(const AppState());
    registerFallbackValue(FakeLaunchOptions());
  });

  setUp(() {
    mockUrlLauncher = MockUrlLauncher();
    UrlLauncherPlatform.instance = mockUrlLauncher;
  });

  group('HelpPage', () {
    testWidgets('should render correctly and expand FAQs', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            appStateProvider.overrideWith(() => MockAppStateNotifier(AppState(loadedFaqs: testFaqs))),
          ],
          child: const HelpPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Frequently Asked Questions'), findsOneWidget);
      expect(find.text('How to shoot?'), findsOneWidget);

      // Expand first FAQ
      await tester.tap(find.text('How to shoot?'));
      await tester.pumpAndSettle();
      expect(find.text('Just release the ball.'), findsOneWidget);

      // Collapse it
      await tester.tap(find.text('How to shoot?'));
      await tester.pumpAndSettle();

      // Cleanup animations
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('should filter FAQs and handle no results', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            appStateProvider.overrideWith(() => MockAppStateNotifier(AppState(loadedFaqs: testFaqs))),
          ],
          child: const HelpPage(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'legs');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text('How to jump?'), findsOneWidget);
      expect(find.text('How to shoot?'), findsNothing);

      // No results
      await tester.enterText(find.byType(TextField), 'nonexistent');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text('No results found.'), findsOneWidget);

      // Disable search
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNothing);

      // Cleanup animations
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('should handle Email Us button', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      when(() => mockUrlLauncher.canLaunch(any())).thenAnswer((_) async => true);
      when(() => mockUrlLauncher.launchUrl(any(), any())).thenAnswer((_) async => true);

      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            appStateProvider.overrideWith(() => MockAppStateNotifier(AppState(loadedFaqs: testFaqs))),
          ],
          child: const HelpPage(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Email Us'));
      await tester.pumpAndSettle();

      verify(() => mockUrlLauncher.launchUrl(any(), any())).called(1);

      // Test failure case
      when(() => mockUrlLauncher.canLaunch(any())).thenAnswer((_) async => false);
      await tester.tap(find.text('Email Us'));
      await tester.pumpAndSettle();
      expect(find.text('No email app found on this device.'), findsOneWidget);

      // Cleanup animations
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('should load fallback FAQs when state is empty', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            appStateProvider
                .overrideWith(() => MockAppStateNotifier(const AppState(loadedFaqs: <Map<String, dynamic>>[]))),
          ],
          child: const HelpPage(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Should load from kDefaultFaqsJson
      expect(find.text('Frequently Asked Questions'), findsOneWidget);
      expect(find.byType(FaqItem), findsAtLeast(1));

      // Cleanup animations
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('tap to unfocus', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
          ],
          child: const HelpPage(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('How can we help you?'));
      await tester.pump();

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
