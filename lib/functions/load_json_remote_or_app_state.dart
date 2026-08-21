import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../logger.dart';

final loadLogger = AppLogger.scope('JsonLoader');

/// Tries remote JSON first, then falls back to cached JSON, then finally to hardcoded fallback.
Future<List<Map<String, dynamic>>> loadJsonRemoteOrAppState(
  String remoteName,
  String defaultJsonString,
) async {
  const String baseUrl = "$supabaseDomain/storage/v1/object/public/assets/json/";
  final String remoteUrl = "$baseUrl$remoteName.json";
  final String cacheKey = "cached_json_$remoteName";

  String? jsonString;
  final prefs = await SharedPreferences.getInstance();

  // 1. Try remote fetch
  try {
    final response = await http.get(Uri.parse(remoteUrl)).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      jsonString = response.body;
      loadLogger.i("Loaded remote file: $remoteName");

      // Save to cache for offline use
      await prefs.setString(cacheKey, jsonString);
    } else {
      loadLogger.w("Remote returned ${response.statusCode}: $remoteName");
    }
  } catch (e) {
    loadLogger.d("Remote fetch failed for $remoteName, checking cache");
  }

  // 2. Try Cache fallback
  if (jsonString == null || jsonString.isEmpty) {
    jsonString = prefs.getString(cacheKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      loadLogger.i("Using cached version for: $remoteName");
    }
  }

  // 3. Try Hardcoded fallback
  if (jsonString == null || jsonString.isEmpty) {
    if (defaultJsonString.isNotEmpty) {
      jsonString = defaultJsonString;
      loadLogger.i("Using hardcoded fallback for: $remoteName");
    } else {
      loadLogger.e("No JSON source found for: $remoteName");
      return [];
    }
  }

  // Parse JSON
  try {
    final decoded = json.decode(jsonString);
    if (decoded is List) {
      return decoded.cast<Map<String, dynamic>>();
    } else if (decoded is Map) {
      // If it's a single object (like feedback_strings), wrap it or return as list if expected
      // Looking at existing usage, feedback_strings is a List
      return (decoded as Map<String, dynamic>).entries.map((e) => {e.key: e.value}).toList();
    }
    return [];
  } catch (e, stack) {
    loadLogger.e("JSON parse error for $remoteName", error: e, stackTrace: stack);
    return [];
  }
}
