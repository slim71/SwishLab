import 'dart:typed_data';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockPostgrestFilterBuilder<T> extends Mock implements PostgrestFilterBuilder<T> {}

class MockPostgrestTransformBuilder<T> extends Mock implements PostgrestTransformBuilder<T> {}

class MockSupabaseStorageClient extends Mock implements SupabaseStorageClient {}

class MockStorageFileApi extends Mock implements StorageFileApi {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

class MockAuthResponse extends Mock implements AuthResponse {}

class MockSession extends Mock implements Session {}

class MockPostgrestResponse<T> extends Mock implements PostgrestResponse<T> {}

void setupSupabaseMocks() {
  registerFallbackValue(const FileOptions());
  registerFallbackValue(Uint8List(0));
  registerFallbackValue(CountOption.exact);
}
