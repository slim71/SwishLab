import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:swish_lab/constants.dart';
import 'package:swish_lab/logger.dart';

final loadLogger = AppLogger.scope('Credits');

/// Tries remote JSON first, then falls back to AppState JSON.
Future<List<Map<String, dynamic>>> loadJsonRemoteOrAppState(
  String remoteName,
  String defaultName,
) async {
  const String baseUrl = "$supabaseDomain/storage/v1/object/public/assets/json/";
  final String remoteUrl = "$baseUrl$remoteName.json";
  String? jsonString;

  // Try remote
  try {
    final response = await http.get(Uri.parse(remoteUrl));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      jsonString = response.body;
      loadLogger.i("Loaded remote file: $remoteName");
    } else {
      loadLogger.w("Remote returned ${response.statusCode}: $remoteName");
    }
  } catch (e) {
    loadLogger.d("Remote fetch failed, falling back to AppState");
  }

  // Try fallback AppState (by name)
  if (jsonString == null || jsonString.isEmpty) {
    if (defaultName.isNotEmpty) {
      jsonString = defaultName;
      loadLogger.i("Using default local fallback");
    } else {
      loadLogger.e("Fallback JSON is empty");
      return [];
    }
  }

  // Parse JSON
  try {
    final List<Map<String, dynamic>> data = json.decode(jsonString);
    loadLogger.i("Parsed ${data.length} entries from JSON content : $data");
    return data;
  } catch (e, stack) {
    loadLogger.e("JSON parse error", error: e, stackTrace: stack);
    return [];
  }
}