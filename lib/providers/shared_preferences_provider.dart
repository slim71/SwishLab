import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for SharedPreferences.
///
/// This provider must be overridden in the [ProviderScope] at the root
/// of the application (main.dart) because SharedPreferences initialization
/// is asynchronous.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider was not overridden');
});
