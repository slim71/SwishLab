import 'dart:async';
import 'dart:typed_data';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

// ignore: must_be_immutable
class MockPostgrestFilterBuilder<T> extends Mock implements PostgrestFilterBuilder<T> {
  dynamic mockFuture;

  @override
  Future<R> then<R>(FutureOr<R> Function(T) onValue, {Function? onError}) async {
    if (mockFuture != null) {
      final value = await mockFuture;
      return onValue(value as T);
    }
    try {
      final fallback = super.noSuchMethod(
        Invocation.method(#then, [onValue], {#onError: onError}),
      );
      if (fallback is Future<R>) return fallback;
      return onValue(null as T);
    } catch (_) {
      return onValue(null as T);
    }
  }
}

// ignore: must_be_immutable
class MockPostgrestTransformBuilder<T> extends Mock implements PostgrestTransformBuilder<T> {
  dynamic mockFuture;

  @override
  Future<R> then<R>(FutureOr<R> Function(T) onValue, {Function? onError}) async {
    if (mockFuture != null) {
      final value = await mockFuture;
      return onValue(value as T);
    }
    try {
      final fallback = super.noSuchMethod(
        Invocation.method(#then, [onValue], {#onError: onError}),
      );
      if (fallback is Future<R>) return fallback;
      return onValue(null as T);
    } catch (_) {
      return onValue(null as T);
    }
  }
}

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

void stubPostgrestAwaitable<T>(dynamic builder, dynamic result) {
  if (builder is MockPostgrestFilterBuilder<T>) {
    builder.mockFuture = result;
  } else if (builder is MockPostgrestTransformBuilder<T>) {
    builder.mockFuture = result;
  }
}
