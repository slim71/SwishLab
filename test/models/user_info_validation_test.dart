import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/models/user_info_validation.dart';

void main() {
  group('UserInfoValidation', () {
    test('default values are true', () {
      final validation = UserInfoValidation();
      expect(validation.firstNameValid, isTrue);
      expect(validation.lastNameValid, isTrue);
      expect(validation.emailValid, isTrue);
      expect(validation.shootingHandValid, isTrue);
      expect(validation.isAllValid, isTrue);
    });

    test('isAllValid returns false if any field is invalid', () {
      expect(UserInfoValidation(firstNameValid: false).isAllValid, isFalse);
      expect(UserInfoValidation(lastNameValid: false).isAllValid, isFalse);
      expect(UserInfoValidation(emailValid: false).isAllValid, isFalse);
      expect(UserInfoValidation(shootingHandValid: false).isAllValid, isFalse);
    });
  });
}
