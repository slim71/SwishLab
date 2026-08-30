import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:swish_lab/pages/about.dart';
import 'package:swish_lab/widgets/icon_action_button.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import '../test_helper.dart';

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(FakeLaunchOptions());
  });

  group('AboutUs', () {
    late MockUrlLauncher mockUrlLauncher;

    setUp(() {
      mockUrlLauncher = MockUrlLauncher();
      UrlLauncherPlatform.instance = mockUrlLauncher;

      when(() => mockUrlLauncher.launchUrl(any(), any()))
          .thenAnswer((_) async => true);
    });

    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AboutUs(),
        ),
      );

      expect(find.text('About Us'), findsOneWidget);
      expect(find.text('Simone Vollaro'), findsOneWidget);
      expect(find.text('Who am I?'), findsOneWidget);

      // Cleanup animations to avoid pending timers
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('should handle reddit link in text', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(
        createTestWidget(
          child: const AboutUs(),
        ),
      );

      // Use pump instead of pumpAndSettle to avoid infinite shimmer timeout
      await tester.pump(const Duration(seconds: 1));

      final redditLink =
          find.textContaining('r/BasketballTips', findRichText: true);
      expect(redditLink, findsOneWidget);

      await tester.tap(redditLink, warnIfMissed: false);
      await tester.pump();

      verify(() => mockUrlLauncher.launchUrl(any(), any())).called(1);

      // Cleanup animations
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('should handle scroll offset listener', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(
        createTestWidget(
          child: const AboutUs(),
        ),
      );
      await tester.pump(const Duration(seconds: 1));

      final scrollable = find.byType(SingleChildScrollView);
      expect(scrollable, findsOneWidget);

      await tester.drag(scrollable, const Offset(0, -200));
      await tester.pump();

      // Cleanup animations
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('should unfocus on background tap', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AboutUs(),
        ),
      );
      await tester.pump(const Duration(seconds: 1));

      final gestureDetector = find.byType(GestureDetector).first;
      await tester.tap(gestureDetector);
      await tester.pump();

      // Cleanup animations
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('should handle social action buttons', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(
        createTestWidget(
          child: const AboutUs(),
        ),
      );
      await tester.pump(const Duration(seconds: 1));

      final buttons = find.byType(IconActionButton);
      expect(buttons, findsNWidgets(6));

      // Alternatively, just skip the first one if we know it's the back button.
      for (int i = 0; i < buttons.evaluate().length; i++) {
        final button = buttons.at(i);
        // Tapping the back button causes errors because we're not mocking the router navigation fully here.
        // Let's just tap buttons that are not the back button.
        final iconFinder = find.descendant(
            of: button, matching: find.byIcon(Icons.arrow_back_rounded));
        if (iconFinder.evaluate().isNotEmpty) continue;

        await tester.tap(button, warnIfMissed: false);
        await tester.pump();
      }

      verify(() => mockUrlLauncher.launchUrl(any(), any())).called(5);

      // Cleanup animations
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
