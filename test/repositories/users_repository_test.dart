import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swish_lab/repositories/users_repository.dart';
import '../supabase_mock.dart';

void main() {
  late MockSupabaseClient client;
  late UsersRepository repository;
  late MockSupabaseQueryBuilder queryBuilder;
  late MockPostgrestFilterBuilder<PostgrestList> filterBuilder;
  late MockPostgrestTransformBuilder<PostgrestList> transformListBuilder;
  late MockPostgrestTransformBuilder<PostgrestMap?> transformMapBuilder;

  setUpAll(() {
    setupSupabaseMocks();
  });

  setUp(() {
    client = MockSupabaseClient();
    repository = UsersRepository(client);
    queryBuilder = MockSupabaseQueryBuilder();
    filterBuilder = MockPostgrestFilterBuilder<PostgrestList>();
    transformListBuilder = MockPostgrestTransformBuilder<PostgrestList>();
    transformMapBuilder = MockPostgrestTransformBuilder<PostgrestMap?>();

    when(() => client.from(any())).thenAnswer((_) => queryBuilder);
    when(() => queryBuilder.select(any())).thenAnswer((_) => filterBuilder);
    when(() => queryBuilder.select()).thenAnswer((_) => filterBuilder);
    when(() => queryBuilder.insert(any())).thenAnswer((_) => filterBuilder);
    when(() => queryBuilder.update(any())).thenAnswer((_) => filterBuilder);
    when(() => filterBuilder.eq(any(), any())).thenAnswer((_) => filterBuilder);
    when(() => filterBuilder.select(any())).thenAnswer((_) => transformListBuilder);
    when(() => filterBuilder.select()).thenAnswer((_) => transformListBuilder);
    when(() => filterBuilder.maybeSingle()).thenAnswer((_) => transformMapBuilder);
    when(() => transformListBuilder.maybeSingle()).thenAnswer((_) => transformMapBuilder);

    // Default awaitable stubs
    stubPostgrestAwaitable<PostgrestList>(filterBuilder, <Map<String, dynamic>>[]);
    stubPostgrestAwaitable<PostgrestList>(transformListBuilder, <Map<String, dynamic>>[]);
    stubPostgrestAwaitable<PostgrestMap?>(transformMapBuilder, null);
  });

  group('UsersRepository', () {
    test('getUserById returns users when found', () async {
      final userData = <Map<String, dynamic>>[
        {'id': '123', 'first_name': 'John', 'last_name': 'Doe', 'email': 'john@example.com'}
      ];
      stubPostgrestAwaitable<PostgrestList>(filterBuilder, userData);

      final result = await repository.getUserById('123');

      expect(result.length, 1);
      expect(result.first.id, '123');
    });

    test('getUserRow returns user when found', () async {
      final userData = {'id': '123', 'first_name': 'John', 'last_name': 'Doe', 'email': 'john@example.com'};
      stubPostgrestAwaitable<PostgrestMap?>(transformMapBuilder, userData);

      final result = await repository.getUserRow('123');

      expect(result?.id, '123');
      expect(result?.firstName, 'John');
    });

    test('getUserRow returns null when not found', () async {
      stubPostgrestAwaitable<PostgrestMap?>(transformMapBuilder, null);

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
      stubPostgrestAwaitable<PostgrestMap?>(transformMapBuilder, userData);

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
      stubPostgrestAwaitable<PostgrestMap?>(transformMapBuilder, userData);

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
      stubPostgrestAwaitable<PostgrestMap?>(transformMapBuilder, null);
      final result = await repository.update(userId: '123', data: {'key': 'val'});
      expect(result, isNull);
    });
  });
}
