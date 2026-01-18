import 'dart:io';

import 'package:SwishLab/functions/local_image_from_url.dart';
import 'package:SwishLab/repositories/storage_repository.dart';
import 'package:SwishLab/repositories/users_repository.dart';

class ChangeProfilePicture {
  final UsersRepository usersRepository;
  final StorageRepository storageRepository;

  ChangeProfilePicture({
    required this.usersRepository,
    required this.storageRepository,
  });

  Future<String> execute({
    required String userId,
    File? localFile,
    String? networkUrl,
  }) async {
    if (localFile == null && (networkUrl == null || networkUrl.isEmpty)) {
      throw Exception('No image provided');
    }

    // Ensure local file
    final File file = localFile ?? await localImageFromUrl(networkUrl!);

    // Upload
    final publicUrl = await storageRepository.uploadProfilePicture(file: file);

    // Fetch previous user
    final previousUser = await usersRepository.getUserRow(userId);
    final previousUrl = previousUser?.profilePic;

    // Update DB
    final updatedUser = await usersRepository.updateProfilePicture(
      userId: userId,
      profilePicUrl: publicUrl,
    );

    if (updatedUser == null) {
      throw Exception('Failed to update user');
    }

    // Cleanup old image
    if (previousUrl != null && previousUrl.isNotEmpty && previousUrl != publicUrl) {
      await storageRepository.deleteByPublicUrl(previousUrl);
    }

    return publicUrl;
  }
}
