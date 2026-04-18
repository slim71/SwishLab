import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swish_lab/features/update_user_field.dart';
import 'package:swish_lab/features/upload_profile_picture.dart';
import 'package:swish_lab/models/users_row.dart';
import 'package:swish_lab/providers/storage_providers.dart';
import 'package:swish_lab/providers/supabase_provider.dart';
import 'package:swish_lab/repositories/users_repository.dart';

import 'auth_providers.dart';

// Provider used to load data from the Users table in Supabase

/// Repository provider (single source of truth)
final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return UsersRepository(supabase);
});

/// Application user record, from DB "Users" table.
/// Use for profile and app-related ops, and as foreign key for other DB tables.
final appUserProvider = FutureProvider<UsersRow?>((ref) async {
  final repo = ref.watch(usersRepositoryProvider);
  final user = ref.watch(authUserProvider);

  if (user == null) return null;

  return repo.getUserRow(user.id);
});

/// Simple changes of the user's info
final updateUserProvider = Provider<UpdateUser>((ref) {
  return UpdateUser(
    usersRepository: ref.read(usersRepositoryProvider),
  );
});

/// To trigger the profile picture change, comprising of:
/// - fetching user row
/// - image upload
/// - old pic deletion
final changeProfilePictureProvider = Provider<ChangeProfilePicture>((ref) {
  return ChangeProfilePicture(
    usersRepository: ref.read(usersRepositoryProvider),
    storageRepository: ref.read(storageRepositoryProvider),
    updateUser: ref.read(updateUserProvider),
  );
});
