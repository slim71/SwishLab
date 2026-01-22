import 'package:SwishLab/features/update_user_field.dart';
import 'package:SwishLab/features/upload_profile_picture.dart';
import 'package:SwishLab/models/users_row.dart';
import 'package:SwishLab/providers/storage_providers.dart';
import 'package:SwishLab/providers/supabase_provider.dart';
import 'package:SwishLab/repositories/users_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final supabase = ref.watch(supabaseProvider);

  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return null;

  return repo.getUserRow(userId);
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
