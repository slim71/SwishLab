import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/pages/theme_test_page.dart';
import '../test_helper.dart';

void main() {
  group('ThemeTestPage', () {
    testWidgets('should render correctly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(
        createTestWidget(
          child: const ThemeTestPage(),
        ),
      );

      // Search for SWISHLAB or THEME depending on how it's rendered
      expect(find.textContaining('Theme', findRichText: true), findsOneWidget);
      expect(find.textContaining('Styles', findRichText: true), findsAtLeast(1));
    });
  });
}
