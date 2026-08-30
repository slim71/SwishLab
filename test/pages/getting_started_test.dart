import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/pages/getting_started.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:swish_lab/widgets/dark_button.dart';
import '../test_helper.dart';

class MockAppStateNotifier extends AppStateNotifier {
  final AppState initialState;
  MockAppStateNotifier(this.initialState);

  @override
  AppState build() => initialState;

  @override
  void setHasOpenedBefore(bool value) {
    state = state.copyWith(hasOpenedBefore: value);
  }
}

void main() {
  group('GettingStartedPage', () {
    testWidgets('should render and navigate through all slides', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
          ],
          child: const GettingStartedPage(),
        ),
      );

      expect(find.text('Pick your angle'), findsOneWidget);

      // Navigate using IconActionButton (the one with next icon)
      for (int i = 0; i < 4; i++) {
        final nextButton = find.byIcon(Icons.navigate_next_rounded);
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
      }

      expect(find.text('Review your performance'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);

      // Tap Get Started
      await tester.tap(find.byType(DarkButton));
      await tester.pumpAndSettle();

      expect(find.text('Home Page'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('back button behavior when not opened before', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(hasOpenedBefore: false))),
          ],
          child: const GettingStartedPage(),
        ),
      );

      final backButton = find.byIcon(Icons.arrow_back_rounded);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.text('Home Page'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('back button present even when opened before', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(hasOpenedBefore: true))),
          ],
          child: const GettingStartedPage(),
        ),
      );

      // MyAppBar currently builds the button if style is backButtonTitleLeft
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('parallax effect logic coverage', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
          ],
          child: const GettingStartedPage(),
        ),
      );

      await tester.drag(find.byType(PageView), const Offset(-200, 0));
      await tester.pump();

      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
