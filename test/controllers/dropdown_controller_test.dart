import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/controllers/dropdown_controller.dart';

void main() {
  group('DropdownController', () {
    test('initial value is set correctly', () {
      final controller = DropdownController<int>(value: 10);
      expect(controller.value, 10);
    });

    test('setValue updates value and notifies listener', () {
      final controller = DropdownController<int>(value: 1);
      bool notified = false;
      controller.addListener(() => notified = true);

      controller.setValue(2);
      expect(controller.value, 2);
      expect(notified, isTrue);
    });

    test('notify calls listener', () {
      final controller = DropdownController<int>();
      bool notified = false;
      controller.addListener(() => notified = true);

      controller.notify();
      expect(notified, isTrue);
    });
  });
}
