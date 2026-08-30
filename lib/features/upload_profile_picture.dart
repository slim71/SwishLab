import 'dart:io';

import '../logger.dart';
import '../functions/local_image_from_url.dart';
import '../repositories/storage_repository.dart';
import '../repositories/users_repository.dart';
import 'update_user_field.dart';

typedef LocalImageDownloader = Future<File> Function(String url);

class ChangeProfilePicture {
  final UsersRepository usersRepository;
  final StorageRepository storageRepository;
  final UpdateUser updateUser;
  final LocalImageDownloader localImageDownloader;
  final _logger = AppLogger.scope('ChangeProfilePicture');

  ChangeProfilePicture({
    required this.usersRepository,
    required this.storageRepository,
    required this.updateUser,
    this.localImageDownloader = localImageFromUrl,
  });

  Future<String> execute({
    required String userId,
    File? localFile,
    String? networkUrl,
  }) async {
    _logger.i('Starting profile picture change for user: $userId');

    if (localFile == null && (networkUrl == null || networkUrl.isEmpty)) {
      _logger.e('No image source provided for user: $userId');
      throw Exception('No image provided');
    }

    try {
      // Ensure local file exists
      final File file = localFile ?? await localImageDownloader(networkUrl!);
      _logger.d('Image file ready for upload: ${file.path}');

      // Upload
      final publicUrl = await storageRepository.uploadProfilePicture(file: file);
      _logger.i('Image uploaded successfully. Public URL: $publicUrl');

      // Fetch previous user to clean up old picture
      final previousUser = await usersRepository.getUserRow(userId);
      final previousUrl = previousUser?.profilePic;

      await updateUser.execute(
        userId: userId,
        data: {'profile_pic': publicUrl},
      );

      // Delete old picture if it exists and is different
      if (previousUrl != null && previousUrl.isNotEmpty && previousUrl != publicUrl) {
        _logger.i('Deleting old profile picture: $previousUrl');
        await storageRepository.deleteByPublicUrl(previousUrl).catchError((Object e) {
          _logger.w('Failed to delete old profile picture, ignoring: $e');
        });
      }

      return publicUrl;
    } catch (e, st) {
      _logger.e('Failed to change profile picture for user: $userId', error: e, stackTrace: st);
      rethrow;
    }
  }
}
