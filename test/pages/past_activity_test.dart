import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/pages/past_activity.dart';
import '../test_helper.dart';

void main() {
  group('PastActivity', () {
    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const PastActivity(),
        ),
      );

      expect(find.text('Past Activity'), findsOneWidget);
      expect(find.textContaining('All activity from this past month'), findsOneWidget);
    });
  });
}
