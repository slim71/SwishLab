import 'package:SwishLab/features/upload_profile_picture.dart';
import 'package:SwishLab/providers/storage_providers.dart';
import 'package:SwishLab/providers/users_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final changeProfilePictureProvider = Provider<ChangeProfilePicture>((ref) {
  return ChangeProfilePicture(
    usersRepository: ref.read(usersRepositoryProvider),
    storageRepository: ref.read(storageRepositoryProvider),
  );
});
