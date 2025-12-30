import 'package:SwishLab/models/users_row.dart';
import 'package:SwishLab/repositories/users_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider used to load data from the Users table in Supabase

/// Repository provider (single source of truth)
final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepository(Supabase.instance.client);
});

/// Current user (by Supabase auth UID)
final currentUserProvider = FutureProvider<UsersRow?>((ref) async {
  final repo = ref.watch(usersRepositoryProvider);

  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return null;

  return repo.getSingleUserById(userId);
});
