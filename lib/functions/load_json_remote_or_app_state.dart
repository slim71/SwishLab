import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../logger.dart';

final loadLogger = AppLogger.scope('JsonLoader');

/// Factory for http client, allows overriding in tests for background refresh
http.Client Function() httpClientFactory = () => http.Client();

/// Tries remote JSON first, then falls back to cached JSON, then finally to hardcoded fallback.
Future<List<Map<String, dynamic>>> loadJsonRemoteOrAppState(
  String remoteName,
  String defaultJsonString, {
  http.Client? client,
}) async {
  const String baseUrl = "$supabaseDomain/storage/v1/object/public/assets/json/";
  final String remoteUrl = "$baseUrl$remoteName.json";
  final String cacheKey = "cached_json_$remoteName";

  final prefs = await SharedPreferences.getInstance();

  // 1. Try Cache first for speed (Stale-While-Revalidate pattern)
  final cachedJson = prefs.getString(cacheKey);

  // Define a background refresh task
  Future<void> refreshRemote() async {
    try {
      // Use a fresh client for background refresh to ensure it doesn't fail if the original client is closed.
      final httpClient = httpClientFactory();
      try {
        final response = await httpClient.get(Uri.parse(remoteUrl)).timeout(const Duration(seconds: 10));
        if (response.statusCode == 200 && response.body.isNotEmpty) {
          await prefs.setString(cacheKey, response.body);
          loadLogger.d("Background refresh success for: $remoteName");
        }
      } finally {
        httpClient.close();
      }
    } catch (e) {
      loadLogger.d("Background refresh failed for $remoteName");
    }
  }

  if (cachedJson != null && cachedJson.isNotEmpty) {
    loadLogger.i("Using cached version for: $remoteName (Refreshing in background)");
    // Fire and forget background refresh
    unawaited(refreshRemote());
    return _parseJson(cachedJson, remoteName);
  }

  // 2. No cache? Try remote fetch (and wait)
  try {
    final httpClient = client ?? http.Client();
    final response = await httpClient.get(Uri.parse(remoteUrl)).timeout(const Duration(seconds: 5));
    if (client == null) httpClient.close();

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      await prefs.setString(cacheKey, response.body);
      loadLogger.i("Loaded remote file: $remoteName");
      return _parseJson(response.body, remoteName);
    }
  } catch (e) {
    loadLogger.w("Initial remote fetch failed for $remoteName");
  }

  // 3. Try Hardcoded fallback
  if (defaultJsonString.isNotEmpty) {
    loadLogger.i("Using hardcoded fallback for: $remoteName");
    return _parseJson(defaultJsonString, remoteName);
  }

  loadLogger.e("No JSON source found for: $remoteName");
  return <Map<String, dynamic>>[];
}

List<Map<String, dynamic>> _parseJson(String jsonString, String remoteName) {
  try {
    final decoded = json.decode(jsonString);
    if (decoded is List) {
      return decoded.cast<Map<String, dynamic>>();
    } else if (decoded is Map) {
      return (decoded as Map<String, dynamic>).entries.map((e) => <String, dynamic>{e.key: e.value}).toList();
    }
    return <Map<String, dynamic>>[];
  } catch (e, stack) {
    loadLogger.e("JSON parse error for $remoteName", error: e, stackTrace: stack);
    return <Map<String, dynamic>>[];
  }
}
