import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swish_lab/widgets/section_details.dart';
import 'package:swish_lab/providers/feedback_provider.dart';

void main() {
  group('SectionDetails', () {
    testWidgets('renders and handles drag flings', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));
      final sectionData = {
        'section': 'Jump',
        'fields': [
          {'name': 'Field 1', 'value': 10.0, 'unit': 'deg', 'range': '0-20'}
        ],
        'scores': [
          {'name': 'Height', 'value': 0.8},
          {'name': 'Total', 'value': 0.9}
        ]
      };

      await tester.pumpWidget(ProviderScope(
        overrides: [feedbackProvider.overrideWith((ref) => <Map<String, dynamic>>[])],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => SectionDetails(sectionJson: sectionData),
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      ));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Details'), findsOneWidget);

      // Test drag up (expansion)
      await tester.drag(find.byType(SectionDetails), const Offset(0, -50));
      await tester.pumpAndSettle();
      expect(find.byType(SectionDetails), findsOneWidget);

      // Test high velocity drag down to close (PrimaryVelocity > 600)
      await tester.fling(find.byType(SectionDetails), const Offset(0, 200), 3000);
      await tester.pumpAndSettle();
      expect(find.byType(SectionDetails), findsNothing);

      // Test drag down far to close (Height < 0.2*H)
      await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.drag(find.byType(SectionDetails), const Offset(0, 500));
      await tester.pumpAndSettle();
      expect(find.byType(SectionDetails), findsNothing);

      // Test tapping background to close
      await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.byType(SectionDetails), findsNothing);

      // Test tapping the grip lines to close
      await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FaIcon).first);
      await tester.pumpAndSettle();
      expect(find.byType(SectionDetails), findsNothing);
    });

    testWidgets('hits all image extension branches and data formats', (WidgetTester tester) async {
      final sections = [
        'jump',
        'set_point',
        'shot_path',
        'elbow_position',
        'feet_direction',
        'follow_through',
        'unknown_section'
      ];

      for (final section in sections) {
        final sectionData = {
          'section': section,
          'fields': [
            {'name': 'F1', 'value': 10.5, 'unit': 'u', 'range': 'r'},
            {'name': 'F2', 'value': '20.0', 'unit': 'u', 'range': 'r'},
            {'name': 'F3', 'value': null, 'unit': 'u', 'range': 'r'},
            {'name': 'F4', 'value': 'abc', 'unit': 'u', 'range': 'r'},
          ],
          'scores': [
            {'name': 'S1', 'value': 0.5},
            {'name': 'S2', 'value': '0.75'},
            {'name': 'S3', 'value': null},
          ]
        };

        await tester.pumpWidget(ProviderScope(
          overrides: [
            feedbackProvider.overrideWith((ref) => <Map<String, dynamic>>[]),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SectionDetails(sectionJson: sectionData),
            ),
          ),
        ));
        await tester.pump(); // initState callback

        expect(find.text('Details'), findsOneWidget);
        // Find RichText containing values
        expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('10.5')), findsOneWidget);
        expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('20.0')), findsOneWidget);
        expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('NA')), findsNWidgets(2));

        // Tap area to hit Focus Scope unfocus
        await tester.tap(find.text('Details'));
        await tester.pump();
      }
    });

    testWidgets('handles missing fields and scores lists', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [feedbackProvider.overrideWith((ref) => <Map<String, dynamic>>[])],
        child: const MaterialApp(
          home: Scaffold(
            body: SectionDetails(sectionJson: {'section': 'Test'}),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Scores'), findsOneWidget);
    });
  });
}
