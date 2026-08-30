import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/models/user_row_data.dart';

void main() {
  group('UserRowData', () {
    final now = DateTime.now();
    const userData = UserRowData(
      userID: 'user1',
      firstName: 'Jane',
      lastName: 'Smith',
      eMail: 'jane@example.com',
    );

    test('fromJson creates a valid object', () {
      final json = {
        'UserID': 'user1',
        'firstName': 'Jane',
        'lastName': 'Smith',
        'eMail': 'jane@example.com',
        'profilePicture': 'url',
        'registrationDate': now.toIso8601String(),
        'shootingHand': 'Left',
      };
      final result = UserRowData.fromJson(json);
      expect(result.userID, 'user1');
      expect(result.firstName, 'Jane');
      expect(result.registrationDate, isNotNull);
      expect(result.shootingHand, 'Left');
    });

    test('fromJson handles null registrationDate', () {
      final json = {
        'UserID': 'user1',
        'firstName': 'Jane',
        'lastName': 'Smith',
        'eMail': 'jane@example.com',
        'profilePicture': 'url',
      };
      final result = UserRowData.fromJson(json);
      expect(result.registrationDate, isNull);
    });

    test('toJson returns a valid map', () {
      final result = userData.toJson();
      expect(result['UserID'], 'user1');
      expect(result['firstName'], 'Jane');
    });

    test('copyWith works correctly', () {
      final regDate = DateTime(2023, 1, 1);
      final updated = userData.copyWith(
        userID: 'new-id',
        firstName: 'Janet',
        lastName: 'Brown',
        eMail: 'janet@brown.com',
        profilePicture: 'new-url',
        registrationDate: regDate,
        shootingHand: 'Right',
      );
      expect(updated.userID, 'new-id');
      expect(updated.firstName, 'Janet');
      expect(updated.lastName, 'Brown');
      expect(updated.eMail, 'janet@brown.com');
      expect(updated.profilePicture, 'new-url');
      expect(updated.registrationDate, regDate);
      expect(updated.shootingHand, 'Right');

      final updated2 = userData.copyWith();
      expect(updated2.firstName, userData.firstName);
    });

    test('equality and hashCode', () {
      final u1 = const UserRowData(userID: '1', firstName: 'A');
      final u2 = const UserRowData(userID: '1', firstName: 'A');
      final u3 = const UserRowData(userID: '2', firstName: 'B');

      expect(u1, u2);
      expect(u1.hashCode, u2.hashCode);
      expect(u1 == u3, isFalse);
    });

    test('default constructor values', () {
      const def = UserRowData();
      expect(def.userID, '<User>');
      expect(def.firstName, 'UserName');
    });
  });
}
