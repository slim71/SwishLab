import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/storage_repository.dart';
import 'supabase_provider.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  final supabase = ref.read(supabaseProvider);
  return StorageRepository(supabase);
});
