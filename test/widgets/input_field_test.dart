import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/widgets/input_field.dart';
import '../test_helper.dart';

void main() {
  late TextEditingController controller;

  setUp(() {
    controller = TextEditingController();
  });

  tearDown(() {
    controller.dispose();
  });

  testWidgets('InputField allows only matched regex characters', (WidgetTester tester) async {
    // Regex allowing only letters
    final allowRegex = RegExp(r'[a-zA-Z]');

    await tester.pumpWidget(createTestWidget(
      child: Scaffold(
        body: InputField(
          controller: controller,
          label: 'Test Field',
          allowRegex: allowRegex,
        ),
      ),
    ));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'Hello123!');
    expect(controller.text, 'Hello');
  });

  testWidgets('InputField denies matched regex characters', (WidgetTester tester) async {
    // Regex denying digits
    final denyRegex = RegExp(r'\d');

    await tester.pumpWidget(createTestWidget(
      child: Scaffold(
        body: InputField(
          controller: controller,
          label: 'Test Field',
          denyRegex: denyRegex,
        ),
      ),
    ));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'Test123Case');
    expect(controller.text, 'TestCase');
  });

  testWidgets('InputField toggles password visibility', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(
      child: Scaffold(
        body: InputField(
          controller: controller,
          label: 'Password',
          obscureText: true,
        ),
      ),
    ));
    await tester.pump();

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.obscureText, isTrue);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();

    final visibleTextField = tester.widget<TextField>(find.byType(TextField));
    expect(visibleTextField.obscureText, isFalse);
  });
}
