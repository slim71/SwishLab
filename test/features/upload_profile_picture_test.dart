import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/features/update_user_field.dart';
import 'package:swish_lab/features/upload_profile_picture.dart';
import 'package:swish_lab/models/users_row.dart';
import 'package:swish_lab/repositories/storage_repository.dart';
import 'package:swish_lab/repositories/users_repository.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

class MockStorageRepository extends Mock implements StorageRepository {}

class MockUpdateUser extends Mock implements UpdateUser {}

class MockFile extends Mock implements File {}

void main() {
  late UsersRepository usersRepository;
  late StorageRepository storageRepository;
  late UpdateUser updateUser;
  late ChangeProfilePicture changeProfilePicture;

  setUp(() {
    usersRepository = MockUsersRepository();
    storageRepository = MockStorageRepository();
    updateUser = MockUpdateUser();
  });

  group('ChangeProfilePicture', () {
    const userId = 'user123';
    const publicUrl = 'https://supabase.com/pic.jpg';
    const previousUrl = 'https://supabase.com/old.jpg';
    final userRow = const UsersRow(
      id: userId,
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      profilePic: previousUrl,
    );

    test('executes successfully with local file', () async {
      final mockFile = MockFile();
      when(() => mockFile.path).thenReturn('test.png');
      changeProfilePicture = ChangeProfilePicture(
        usersRepository: usersRepository,
        storageRepository: storageRepository,
        updateUser: updateUser,
      );

      when(() => storageRepository.uploadProfilePicture(file: mockFile)).thenAnswer((_) async => publicUrl);
      when(() => usersRepository.getUserRow(userId)).thenAnswer((_) async => userRow);
      when(() => updateUser.execute(userId: userId, data: {'profile_pic': publicUrl}))
          .thenAnswer((_) async => userRow.copyWith(profilePic: publicUrl));
      when(() => storageRepository.deleteByPublicUrl(any())).thenAnswer((_) async {});

      final result = await changeProfilePicture.execute(userId: userId, localFile: mockFile);

      expect(result, equals(publicUrl));
      verify(() => storageRepository.uploadProfilePicture(file: mockFile)).called(1);
      verify(() => updateUser.execute(userId: userId, data: {'profile_pic': publicUrl})).called(1);
      verify(() => storageRepository.deleteByPublicUrl(previousUrl)).called(1);
    });

    test('executes successfully with network URL', () async {
      const networkUrl = 'https://external.com/image.png';
      final mockFile = MockFile();
      when(() => mockFile.path).thenReturn('test.png');

      changeProfilePicture = ChangeProfilePicture(
        usersRepository: usersRepository,
        storageRepository: storageRepository,
        updateUser: updateUser,
        localImageDownloader: (url) async {
          if (url == networkUrl) return mockFile;
          throw Exception('Wrong URL');
        },
      );

      when(() => storageRepository.uploadProfilePicture(file: mockFile)).thenAnswer((_) async => publicUrl);
      when(() => usersRepository.getUserRow(userId)).thenAnswer((_) async => const UsersRow(
            id: userId,
            firstName: 'John',
            lastName: 'Doe',
            email: 'john@example.com',
            profilePic: null,
          ));
      when(() => updateUser.execute(userId: userId, data: {'profile_pic': publicUrl}))
          .thenAnswer((_) async => userRow.copyWith(profilePic: publicUrl));
      when(() => storageRepository.deleteByPublicUrl(any())).thenAnswer((_) async {});

      final result = await changeProfilePicture.execute(userId: userId, networkUrl: networkUrl);

      expect(result, equals(publicUrl));
      verify(() => storageRepository.uploadProfilePicture(file: mockFile)).called(1);
      verifyNever(() => storageRepository.deleteByPublicUrl(any()));
    });

    test('throws exception when no image provided', () async {
      changeProfilePicture = ChangeProfilePicture(
        usersRepository: usersRepository,
        storageRepository: storageRepository,
        updateUser: updateUser,
      );

      expect(
        () => changeProfilePicture.execute(userId: userId),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('No image provided'))),
      );
    });

    test('does not delete if previous URL is the same as new URL', () async {
      final mockFile = MockFile();
      when(() => mockFile.path).thenReturn('test.png');
      changeProfilePicture = ChangeProfilePicture(
        usersRepository: usersRepository,
        storageRepository: storageRepository,
        updateUser: updateUser,
      );

      when(() => storageRepository.uploadProfilePicture(file: mockFile)).thenAnswer((_) async => publicUrl);
      when(() => usersRepository.getUserRow(userId)).thenAnswer((_) async => userRow.copyWith(profilePic: publicUrl));
      when(() => updateUser.execute(userId: userId, data: {'profile_pic': publicUrl}))
          .thenAnswer((_) async => userRow.copyWith(profilePic: publicUrl));

      await changeProfilePicture.execute(userId: userId, localFile: mockFile);

      verifyNever(() => storageRepository.deleteByPublicUrl(any()));
    });
  });
}
