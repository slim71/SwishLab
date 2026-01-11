import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

/// Load Markdown content
Future<String> loadMarkdown(String fileName) async {
  final localPath = 'assets/markdown/$fileName.md';

  try {
    debugPrint("Trying local md: $localPath");
    final localContent = await rootBundle.loadString(localPath);
    return localContent;
  } catch (e, st) {
    debugPrint("Failed to load local md: $e");
    debugPrint(st.toString());
  }

  // Try remote URL
  final remoteUrl = "https://ccqvtpiltowjpogbjmpd.supabase.co/storage/v1/object/public/assets/mds/$fileName.md";

  try {
    debugPrint("Trying remote md: $remoteUrl");
    final response = await http.get(Uri.parse(remoteUrl));
    if (response.statusCode == 200) return response.body;
  } catch (_) {
    debugPrint("Failed to load remote md");
    // ignore errors
  }

  // Fallback
  debugPrint("Fallback to default");
  return '# Content not available';
}
