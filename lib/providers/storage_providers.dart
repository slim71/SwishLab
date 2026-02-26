import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swish_lab/providers/supabase_provider.dart';
import 'package:swish_lab/repositories/storage_repository.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  final supabase = ref.read(supabaseProvider);
  return StorageRepository(supabase);
});
