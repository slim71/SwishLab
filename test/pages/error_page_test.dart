import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/pages/error_page.dart';

void main() {
  group('ErrorPage', () {
    testWidgets('should render default message and button', (tester) async {
      bool homePressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: ErrorPage(
            onHome: () => homePressed = true,
          ),
        ),
      );

      expect(find.text('Oops, something went wrong'), findsOneWidget);
      expect(find.text('Go Home'), findsOneWidget);

      await tester.tap(find.text('Go Home'));
      expect(homePressed, isTrue);
    });

    testWidgets('should render error message in debug mode', (tester) async {
      // Note: kDebugMode is usually true in tests unless specifically changed,
      // but we can't easily change a constant.
      // However, we can verify it shows up if it IS true.

      await tester.pumpWidget(
        MaterialApp(
          home: ErrorPage(
            message: 'Detailed error',
            onHome: () {},
          ),
        ),
      );

      if (kDebugMode) {
        expect(find.text('Detailed error'), findsOneWidget);
      } else {
        expect(find.text('Detailed error'), findsNothing);
      }
    });
  });
}
