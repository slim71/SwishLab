import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageRepository {
  final SupabaseClient _client;

  StorageRepository(this._client);

  Future<String> uploadProfilePicture({
    required File file,
  }) async {
    final bytes = await file.readAsBytes();

    final originalName = p.basenameWithoutExtension(file.path);
    final extension = p.extension(file.path);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${originalName}__$timestamp$extension';
    final storagePath = 'pics/$fileName';

    await _client.storage.from('profile_pictures').uploadBinary(
          storagePath,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    return _client.storage.from('profile_pictures').getPublicUrl(storagePath);
  }

  Future<void> deleteByPublicUrl(String publicUrl) async {
    final uri = Uri.parse(publicUrl);
    final segments = uri.pathSegments;

    final bucketIndex = segments.indexOf('profile_pictures');
    if (bucketIndex == -1 || bucketIndex + 1 >= segments.length) return;

    final filePath = segments.sublist(bucketIndex + 1).join('/');

    await _client.storage.from('profile_pictures').remove([filePath]);
  }
}
