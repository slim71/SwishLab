import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/controllers/dropdown_controller.dart';
import 'package:swish_lab/widgets/drop_down.dart';
import '../test_helper.dart';

void main() {
  testWidgets('Dropdown shows options and updates controller on selection',
      (WidgetTester tester) async {
    final controller = DropdownController<String>(value: 'Option 1');
    final options = ['Option 1', 'Option 2', 'Option 3'];

    await tester.pumpWidget(createTestWidget(
      child: Scaffold(
        body: Dropdown<String>(
          controller: controller,
          options: options,
          hintText: 'Select Option',
        ),
      ),
    ));
    await tester.pump();

    expect(find.text('Option 1'), findsOneWidget);

    await tester.tap(find.text('Option 1'));
    await tester.pumpAndSettle();

    expect(find.text('Option 2').last, findsOneWidget);
    expect(find.text('Option 3').last, findsOneWidget);

    await tester.tap(find.text('Option 2').last);
    await tester.pumpAndSettle();

    expect(controller.value, 'Option 2');
    expect(find.text('Option 2'), findsOneWidget);
  });
}
