import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/router/app_transitions.dart';

class MockGoRouterState extends Mock implements GoRouterState {}

void main() {
  late MockGoRouterState state;

  setUp(() {
    state = MockGoRouterState();
    when(() => state.pageKey).thenReturn(const ValueKey('test'));
  });

  group('buildTransitionPage', () {
    testWidgets('renders AppTransition.none', (tester) async {
      final page = buildTransitionPage<void>(
        state: state,
        child: const Text('child'),
        transition: AppTransition.none,
      );

      await tester.pumpWidget(MaterialApp(home: page.child));
      expect(find.text('child'), findsOneWidget);
    });

    void testTransition(AppTransition transition) {
      testWidgets('renders $transition', (tester) async {
        final page = buildTransitionPage<void>(
          state: state,
          child: const Text('child'),
          transition: transition,
        );

        await tester.pumpWidget(MaterialApp(
          onGenerateRoute: (settings) {
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => page.child,
              transitionsBuilder: page.transitionsBuilder,
              transitionDuration: page.transitionDuration,
            );
          },
        ));

        // Trigger transition
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('child'), findsOneWidget);
      });
    }

    for (final transition in AppTransition.values) {
      if (transition != AppTransition.none) {
        testTransition(transition);
      }
    }
  });
}
