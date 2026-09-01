import 'dart:async';
import 'dart:typed_data';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class FakeSupabaseQueryBuilder extends Fake implements SupabaseQueryBuilder {
  final filterBuilder = FakePostgrestFilterBuilder<List<Map<String, dynamic>>>();

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> select([String columns = '*']) => filterBuilder;

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> insert(Object values,
          {String? onConflict, bool defaultToNull = true}) =>
      filterBuilder;

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> update(Map<dynamic, dynamic> values,
          {bool defaultToNull = true}) =>
      filterBuilder;

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> delete() => filterBuilder;
}

class FakePostgrestFilterBuilder<T> extends Fake implements PostgrestFilterBuilder<T> {
  final transformBuilder = FakePostgrestTransformBuilder<Map<String, dynamic>?>();
  final List<T> _valueContainer = [];

  @override
  PostgrestFilterBuilder<T> eq(String column, Object value) => this;

  @override
  PostgrestTransformBuilder<List<Map<String, dynamic>>> select([String columns = '*']) =>
      this as PostgrestTransformBuilder<List<Map<String, dynamic>>>;

  @override
  PostgrestTransformBuilder<T> order(String column,
          {bool ascending = true, bool nullsFirst = false, String? referencedTable}) =>
      this;

  @override
  PostgrestTransformBuilder<T> limit(int count, {String? referencedTable}) => this;

  @override
  PostgrestTransformBuilder<T> range(int from, int to, {String? referencedTable}) => this;

  @override
  PostgrestTransformBuilder<Map<String, dynamic>?> maybeSingle() => transformBuilder;

  @override
  Future<R> then<R>(FutureOr<R> Function(T) onValue, {Function? onError}) {
    return Future.value(onValue(_valueContainer.first));
  }

  void stub(T value) {
    _valueContainer.clear();
    _valueContainer.add(value);
  }
}

class FakePostgrestTransformBuilder<T> extends Fake implements PostgrestTransformBuilder<T> {
  final List<T> _valueContainer = [];

  @override
  Future<R> then<R>(FutureOr<R> Function(T) onValue, {Function? onError}) {
    return Future.value(onValue(_valueContainer.first));
  }

  void stub(T value) {
    _valueContainer.clear();
    _valueContainer.add(value);
  }
}

class MockSupabaseStorageClient extends Mock implements SupabaseStorageClient {}

class MockStorageFileApi extends Mock implements StorageFileApi {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

class MockAuthResponse extends Mock implements AuthResponse {}

class MockSession extends Mock implements Session {}

/// A helper to mock the fluent interface of Supabase/Postgrest.
/// It stubs the `then` method to return the provided [value].
void stubPostgrestAwaitable(dynamic builder, dynamic value) {
  if (builder is FakePostgrestFilterBuilder) {
    builder.stub(value);
  } else if (builder is FakePostgrestTransformBuilder) {
    builder.stub(value);
  } else {
    when(() => (builder as dynamic).then(any<Function>())).thenAnswer((invocation) {
      final onValue = invocation.positionalArguments[0] as Function;
      return Future.value(onValue(value));
    });
  }
}

void setupSupabaseMocks() {
  registerFallbackValue(const FileOptions());
  registerFallbackValue(Uint8List(0));
}
