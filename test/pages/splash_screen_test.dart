import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/pages/splash_screen.dart';
import '../test_helper.dart';

void main() {
  group('SplashScreen', () {
    testWidgets('renders all pages in PageView', (tester) async {
      await tester.pumpWidget(createTestWidget(
        child: const SplashScreen(),
      ));

      expect(find.text('Understand Your Form'), findsOneWidget);

      // Swipe to second page
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();
      expect(find.text('Keep It Straight'), findsOneWidget);

      // Swipe to third page
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();
      expect(find.text('Perfect the Flow'), findsOneWidget);
    });

    testWidgets('Login button navigates to login page', (tester) async {
      final mockRouter = MockGoRouter();
      await tester.pumpWidget(createTestWidget(
        router: mockRouter,
        child: const SplashScreen(),
      ));

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      verify(() => mockRouter.goNamed('login')).called(1);
    });

    testWidgets('Register button navigates to signup page', (tester) async {
      final mockRouter = MockGoRouter();
      await tester.pumpWidget(createTestWidget(
        router: mockRouter,
        child: const SplashScreen(),
      ));

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      verify(() => mockRouter.goNamed('signup')).called(1);
    });

    testWidgets('unfocuses on background tap', (tester) async {
      await tester.pumpWidget(createTestWidget(
        child: const SplashScreen(),
      ));

      final gestureDetector = find.byType(GestureDetector).first;
      await tester.tap(gestureDetector);
      await tester.pump();
      // Should not crash
    });
  });
}
