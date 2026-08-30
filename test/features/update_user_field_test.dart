import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/features/update_user_field.dart';
import 'package:swish_lab/models/users_row.dart';
import 'package:swish_lab/repositories/users_repository.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

void main() {
  late UsersRepository usersRepository;
  late UpdateUser updateUser;

  setUp(() {
    usersRepository = MockUsersRepository();
    updateUser = UpdateUser(usersRepository: usersRepository);
  });

  group('UpdateUser', () {
    const userId = 'user123';
    const updateData = {'first_name': 'Jane'};
    const userRow = UsersRow(
      id: userId,
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@example.com',
    );

    test('executes successfully and returns updated user', () async {
      when(() => usersRepository.update(userId: userId, data: updateData)).thenAnswer((_) async => userRow);

      final result = await updateUser.execute(userId: userId, data: updateData);

      expect(result, equals(userRow));
      verify(() => usersRepository.update(userId: userId, data: updateData)).called(1);
    });

    test('throws exception when data is empty', () async {
      expect(
        () => updateUser.execute(userId: userId, data: {}),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('No update data provided'))),
      );
      verifyNever(() => usersRepository.update(userId: any(named: 'userId'), data: any(named: 'data')));
    });

    test('throws exception when repository returns null', () async {
      when(() => usersRepository.update(userId: userId, data: updateData)).thenAnswer((_) async => null);

      expect(
        () => updateUser.execute(userId: userId, data: updateData),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Failed to update user'))),
      );
    });
  });
}
