import 'dart:convert';

import 'package:SwishLab/constants.dart';
import 'package:http/http.dart' as http;

/// Tries remote JSON first, then falls back to AppState JSON.
Future<List<Map<String, dynamic>>> loadJsonRemoteOrAppState(
  String remoteName,
  String defaultName,
) async {
  const String baseUrl = "$supabaseDomain/storage/v1/object/public/assets/json/";
  final String remoteUrl = "$baseUrl$remoteName.json";
  String? jsonString;

  // --- 1️⃣ Try remote ---
  try {
    final response = await http.get(Uri.parse(remoteUrl));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      jsonString = response.body;
      print("Loaded remote file: $remoteName");
    } else {
      print("Remote returned ${response.statusCode}: $remoteName");
    }
  } catch (e) {
    print("Remote fetch failed: $e");
  }

  // --- 2️⃣ Try fallback AppState (by name) ---
  if (jsonString == null || jsonString.isEmpty) {
    if (defaultName.isNotEmpty) {
      jsonString = defaultName;
      print("Using default local fallback");
    } else {
      print("Fallback JSON is empty");
      return [];
    }
  }

  // --- 3️⃣ Parse JSON ---
  try {
    final List<Map<String, dynamic>> data = json.decode(jsonString);
    print("Parsed ${data.length} entries from JSON content : $data");
    return data;
  } catch (e) {
    print("JSON parse error: $e");
    return [];
  }
}