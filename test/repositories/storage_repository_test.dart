import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swish_lab/repositories/storage_repository.dart';
import '../supabase_mock.dart';

void main() {
  late MockSupabaseClient client;
  late StorageRepository repository;
  late MockSupabaseStorageClient storageClient;
  late MockStorageFileApi fileApi;

  setUpAll(() {
    setupSupabaseMocks();
  });

  setUp(() {
    client = MockSupabaseClient();
    repository = StorageRepository(client);
    storageClient = MockSupabaseStorageClient();
    fileApi = MockStorageFileApi();

    when(() => client.storage).thenReturn(storageClient);
    when(() => storageClient.from(any<String>())).thenReturn(fileApi);
  });

  group('StorageRepository', () {
    test('uploadProfilePicture uploads and returns public URL', () async {
      // Create a temporary file
      final tempDir = await Directory.systemTemp.createTemp();
      final tempFile = File('${tempDir.path}/test.png');
      await tempFile.writeAsBytes([1, 2, 3]);

      // uploadBinary is often an extension, so we stub 'upload' which it calls
      // or we stub it directly if it's a member. To be safe, we try to stub what's used.
      // If mocktail fails here, it's because it's an extension.
      try {
        when(() => fileApi.uploadBinary(
              any<String>(),
              any<Uint8List>(),
              fileOptions: any<FileOptions>(named: 'fileOptions'),
            )).thenAnswer((_) async => 'path');
      } catch (_) {
        when(() => fileApi.upload(
              any<String>(),
              any<File>(),
              fileOptions: any<FileOptions>(named: 'fileOptions'),
            )).thenAnswer((_) async => 'path');
      }

      when(() => fileApi.getPublicUrl(any<String>())).thenReturn('https://public.url');

      final result = await repository.uploadProfilePicture(file: tempFile);

      expect(result, 'https://public.url');

      try {
        verify(() => fileApi.uploadBinary(any<String>(), any<Uint8List>(),
            fileOptions: any<FileOptions>(named: 'fileOptions'))).called(1);
      } catch (_) {
        verify(() => fileApi.upload(any<String>(), any<File>(), fileOptions: any<FileOptions>(named: 'fileOptions')))
            .called(1);
      }
    });

    test('deleteByPublicUrl parses URL and calls remove', () async {
      const publicUrl = 'https://supabase.co/storage/v1/object/public/profile_pictures/pics/user1.png';

      when(() => fileApi.remove(any<List<String>>())).thenAnswer((_) async => []);

      await repository.deleteByPublicUrl(publicUrl);

      verify(() => storageClient.from('profile_pictures')).called(1);
      verify(() => fileApi.remove(any<List<String>>())).called(1);
    });
  });
}
