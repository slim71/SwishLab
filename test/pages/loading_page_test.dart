import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/pages/loading_page.dart';
import 'package:swish_lab/widgets/dynamic_asset.dart';

void main() {
  group('LoadingPage', () {
    testWidgets('should render correctly and handle tap to unfocus', (tester) async {
      final focusNode = FocusNode();
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TextField(focusNode: focusNode),
                  const Expanded(child: LoadingPage()),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify rendering
      expect(find.byType(DynamicAsset), findsOneWidget);
      expect(find.text('Loading'), findsOneWidget);
      expect(find.text('Please wait...'), findsOneWidget);

      // Focus the text field
      focusNode.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);

      // Tap on LoadingPage (GestureDetector)
      await tester.tap(find.byType(LoadingPage));
      await tester.pump();

      expect(focusNode.hasFocus, isFalse);
    });
  });
}
