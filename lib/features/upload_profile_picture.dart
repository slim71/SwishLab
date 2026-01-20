import 'dart:io';

import 'package:SwishLab/features/update_user_field.dart';
import 'package:SwishLab/functions/local_image_from_url.dart';
import 'package:SwishLab/repositories/storage_repository.dart';
import 'package:SwishLab/repositories/users_repository.dart';

class ChangeProfilePicture {
  final UsersRepository usersRepository;
  final StorageRepository storageRepository;
  final UpdateUser updateUser;

  ChangeProfilePicture({
    required this.usersRepository,
    required this.storageRepository,
    required this.updateUser,
  });

  Future<String> execute({
    required String userId,
    File? localFile,
    String? networkUrl,
  }) async {
    if (localFile == null && (networkUrl == null || networkUrl.isEmpty)) {
      throw Exception('No image provided');
    }

    // Ensure local file exists
    final File file = localFile ?? await localImageFromUrl(networkUrl!);

    // Upload
    final publicUrl = await storageRepository.uploadProfilePicture(file: file);

    // Fetch previous user
    final previousUser = await usersRepository.getUserRow(userId);
    final previousUrl = previousUser?.profilePic;

    await updateUser.execute(
      userId: userId,
      data: {'profile_pic': publicUrl},
    );

    if (previousUrl != null && previousUrl.isNotEmpty && previousUrl != publicUrl) {
      await storageRepository.deleteByPublicUrl(previousUrl);
    }

    return publicUrl;
  }
}

