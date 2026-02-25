import 'dart:convert';

import 'package:SwishLab/constants.dart';
import 'package:SwishLab/logger.dart';
import 'package:SwishLab/models/credit_item.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

final creditsLogger = AppLogger.scope('Credits');

/// Loads a JSON array of credits from local assets or remote Supabase
/// storage.
Future<List<Credit>> loadCredits() async {
  const localPath = 'assets/json/credits.json';
  const remoteUrl = '$supabaseDomain/storage/v1/object/public/assets/json/credits.json';

  String? jsonString;

  // Try local first
  try {
    jsonString = await rootBundle.loadString(localPath);
    if (jsonString.isNotEmpty) creditsLogger.i('Loaded local credits.json');
  } catch (e) {
    creditsLogger.d('Local JSON not found, falling back to remote');
  }

  // Try remote if local not available
  if (jsonString == null || jsonString.isEmpty) {
    try {
      final response = await http.get(Uri.parse(remoteUrl));
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        jsonString = response.body;
        creditsLogger.i('Loaded remote credits.json');
      } else {
        creditsLogger.w('Failed to load remote credits.json: ${response.statusCode}');
      }
    } catch (e, stack) {
      creditsLogger.e('Error fetching remote JSON', error: e, stackTrace: stack);
    }
  }

  // Check content
  if (jsonString == null || jsonString.isEmpty) {
    creditsLogger.w('No JSON data found');
    return [];
  }

  // Parse content
  try {
    final List<dynamic> data = json.decode(jsonString) as List<dynamic>;
    creditsLogger.i('Parsed ${data.length} credit entries');

    return data.cast<Map<String, dynamic>>().map((json) => Credit.fromJson(json)).toList();
  } catch (e, stack) {
    creditsLogger.e('Failed to parse credits JSON', error: e, stackTrace: stack);
    return [];
  }
}
