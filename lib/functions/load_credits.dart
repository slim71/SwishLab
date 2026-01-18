import 'dart:convert';

import 'package:SwishLab/models/credit_item.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

/// Loads a JSON array of credits from local assets or remote Supabase
/// storage.
Future<List<Credit>> loadCredits() async {
  const localPath = 'assets/json/credits.json';
  const remoteUrl = // TODO: use a constant
      'https://ccqvtpiltowjpogbjmpd.supabase.co/storage/v1/object/public/assets/json/credits.json';

  String? jsonString;

  // Try local first
  try {
    jsonString = await rootBundle.loadString(localPath);
    if (jsonString.isNotEmpty) print('Loaded local credits.json');
  } catch (e) {
    print('Local JSON not found, falling back to remote: $e');
  }

  // Try remote if local not available
  if (jsonString == null || jsonString.isEmpty) {
    try {
      final response = await http.get(Uri.parse(remoteUrl));
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        jsonString = response.body;
        print('Loaded remote credits.json');
      } else {
        print('Failed to load remote credits.json: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching remote JSON: $e');
    }
  }

  if (jsonString == null || jsonString.isEmpty) {
    print('No JSON data found');
    return [];
  }

  try {
    final List<dynamic> data = json.decode(jsonString) as List<dynamic>;
    print('Parsed ${data.length} credit entries');

    return data.cast<Map<String, dynamic>>().map((json) => Credit.fromJson(json)).toList();
  } catch (e) {
    print('Failed to parse JSON: $e');
    return [];
  }
}
