import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/models/users_row.dart';

void main() {
  group('UsersRow', () {
    final now = DateTime.now();
    final user = UsersRow(
      id: '123',
      createdAt: now,
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      profilePic: 'pic.png',
      shootingHand: 'Right',
    );

    test('fromJson creates a valid object', () {
      final json = {
        'id': '123',
        'created_at': now.toIso8601String(),
        'first_name': 'John',
        'last_name': 'Doe',
        'email': 'john@example.com',
        'profile_pic': 'pic.png',
        'shooting_hand': 'Right',
      };
      final result = UsersRow.fromJson(json);
      expect(result.id, '123');
      expect(result.firstName, 'John');
      expect(result.createdAt, isA<DateTime>());
    });

    test('fromJson handles null created_at', () {
      final json = {
        'id': '123',
        'first_name': 'John',
        'last_name': 'Doe',
        'email': 'john@example.com',
      };
      final result = UsersRow.fromJson(json);
      expect(result.createdAt, isNull);
    });

    test('toJson returns a valid map', () {
      final result = user.toJson();
      expect(result['id'], '123');
      expect(result['created_at'], now.toIso8601String());
      expect(result['first_name'], 'John');
    });

    test('copyWith works correctly', () {
      final updated = user.copyWith(firstName: 'Jane');
      expect(updated.firstName, 'Jane');
      expect(updated.id, user.id);

      final updated2 = user.copyWith();
      expect(updated2.firstName, user.firstName);
      expect(updated2.id, user.id);
    });

    test('equality and hashCode work correctly', () {
      expect(user == user, isTrue);

      final user2 = const UsersRow(
        id: '123',
        firstName: 'Other',
        lastName: 'Name',
        email: 'other@example.com',
      );
      expect(user == user2, isTrue);
      expect(user.hashCode, user2.hashCode);

      final user3 = user.copyWith(id: '456');
      expect(user == user3, isFalse);
    });

    test('toString returns expected string', () {
      expect(user.toString(), contains('123'));
      expect(user.toString(), contains('john@example.com'));
    });
  });
}
