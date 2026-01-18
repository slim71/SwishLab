import 'package:SwishLab/providers/supabase_provider.dart';
import 'package:SwishLab/repositories/storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  final supabase = ref.read(supabaseProvider);
  return StorageRepository(supabase);
});
