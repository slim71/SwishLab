import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/pages/appearance_settings.dart';
import 'package:swish_lab/styles/theme_manager.dart';
import 'package:swish_lab/styles/colors.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:swish_lab/providers/shared_preferences_provider.dart';
import '../test_helper.dart';

class MockAppStateNotifier extends AppStateNotifier {
  final AppState initialState;
  MockAppStateNotifier(this.initialState);

  @override
  AppState build() => initialState;
}

void main() {
  group('AppearanceSettings', () {
    testWidgets('renders all sections correctly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
        ],
        child: const AppearanceSettings(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('THEME MODE'), findsOneWidget);
      expect(find.text('COLOR SET'), findsOneWidget);
      expect(find.text('ANALYSIS DISPLAY'), findsOneWidget);

      expect(find.text('System'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
    });

    testWidgets('changes theme mode on tap', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      AppThemeManager.setBrightness(AppBrightness.system);

      await tester.pumpWidget(createTestWidget(
        overrides: [
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
        ],
        child: const AppearanceSettings(),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();
      expect(AppThemeManager.brightness, AppBrightness.light);

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();
      expect(AppThemeManager.brightness, AppBrightness.dark);
    });

    testWidgets('changes color set with confirmation', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      // Ensure we have a known color set
      AppThemeManager.setColors(themeList.first);

      await tester.pumpWidget(createTestWidget(
        overrides: [
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
        ],
        child: const AppearanceSettings(),
      ));
      await tester.pumpAndSettle();

      final targetColorSet = themeList.last;
      await tester.tap(find.text(targetColorSet.name));
      await tester.pumpAndSettle();

      expect(find.text('Change Color Set?'), findsOneWidget);

      // Tap Confirm
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(AppThemeManager.currentColors.name, targetColorSet.name);
    });

    testWidgets('cancels color set change', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      final initialColorSet = themeList.first;
      AppThemeManager.setColors(initialColorSet);

      await tester.pumpWidget(createTestWidget(
        overrides: [
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
        ],
        child: const AppearanceSettings(),
      ));
      await tester.pumpAndSettle();

      final targetColorSet = themeList.last;
      await tester.tap(find.text(targetColorSet.name));
      await tester.pumpAndSettle();

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(AppThemeManager.currentColors.name, initialColorSet.name);
    });

    testWidgets('toggles analysis display (radar chart)', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      final mockPrefs = MockSharedPreferences();
      when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);

      final container = createContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(showRadarChart: false))),
        ],
      );

      await tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: AppearanceSettings()),
        ),
      ));

      final toggleFinder = find.byType(Switch);
      expect(tester.widget<Switch>(toggleFinder).value, isFalse);

      await tester.tap(toggleFinder);
      await tester.pumpAndSettle();

      expect(container.read(appStateProvider).showRadarChart, isTrue);
    });
  });
}
