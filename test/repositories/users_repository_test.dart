import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/repositories/users_repository.dart';
import '../supabase_mock.dart';

void main() {
  late MockSupabaseClient client;
  late UsersRepository repository;
  late FakeSupabaseQueryBuilder queryBuilder;
  late FakePostgrestFilterBuilder<List<Map<String, dynamic>>> filterBuilder;
  late FakePostgrestTransformBuilder<dynamic> transformBuilder;

  setUp(() {
    client = MockSupabaseClient();
    repository = UsersRepository(client);
    queryBuilder = FakeSupabaseQueryBuilder();
    filterBuilder = queryBuilder.filterBuilder;
    transformBuilder = filterBuilder.transformBuilder as FakePostgrestTransformBuilder<dynamic>;

    when(() => client.from(any())).thenAnswer((_) => queryBuilder);

    // Default awaitable stubs
    stubPostgrestAwaitable(filterBuilder, <Map<String, dynamic>>[]);
    stubPostgrestAwaitable(transformBuilder, null);
  });

  group('UsersRepository', () {
    test('getUserById returns users when found', () async {
      final userData = <Map<String, dynamic>>[
        {'id': '123', 'first_name': 'John', 'last_name': 'Doe', 'email': 'john@example.com'}
      ];
      stubPostgrestAwaitable(filterBuilder, userData);

      final result = await repository.getUserById('123');

      expect(result.length, 1);
      expect(result.first.id, '123');
    });

    test('getUserRow returns user when found', () async {
      final userData = {'id': '123', 'first_name': 'John', 'last_name': 'Doe', 'email': 'john@example.com'};
      stubPostgrestAwaitable(transformBuilder, userData);

      final result = await repository.getUserRow('123');

      expect(result?.id, '123');
      expect(result?.firstName, 'John');
    });

    test('getUserRow returns null when not found', () async {
      stubPostgrestAwaitable(transformBuilder, null);

      final result = await repository.getUserRow('456');

      expect(result, isNull);
    });

    test('insertUser calls insert', () async {
      await repository.insertUser(
        id: '123',
        email: 'john@example.com',
        firstName: 'John',
        lastName: 'Doe',
      );
    });

    test('update profile picture calls update', () async {
      final userData = {
        'id': '123',
        'first_name': 'John',
        'last_name': 'Doe',
        'email': 'john@example.com',
        'profile_pic': 'new_url'
      };
      stubPostgrestAwaitable(transformBuilder, userData);

      final result = await repository.updateProfilePicture(
        userId: '123',
        profilePicUrl: 'new_url',
      );

      expect(result?.profilePic, 'new_url');
    });

    test('update shooting hand calls update', () async {
      final userData = {
        'id': '123',
        'first_name': 'John',
        'last_name': 'Doe',
        'email': 'john@example.com',
        'shooting_hand': 'Left'
      };
      stubPostgrestAwaitable(transformBuilder, userData);

      final result = await repository.updateShootingHand(
        userId: '123',
        shootingHand: 'Left',
      );

      expect(result?.shootingHand, 'Left');
    });

    test('update returns null if data is empty', () async {
      final result = await repository.update(userId: '123', data: {});
      expect(result, isNull);
    });

    test('update returns null if response is null', () async {
      stubPostgrestAwaitable(transformBuilder, null);
      final result = await repository.update(userId: '123', data: {'key': 'val'});
      expect(result, isNull);
    });
  });
}
